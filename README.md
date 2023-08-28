## Prerequisite

- dns with name server propagated
    - mine: kops.papavonning.com
- S3 for kube state
- S3 for OIDC (discovery-store)

(provisioned in aws using terraform)

## Create cluster

### setup:

- availability zone: us-east-1a (should at least 2..)
- s3 for state: kops-papavonning
- s3 for discovery store:
- cluster
    - master node: 1 in type t2.medium (should be at least 2.. for HA)
    - worker node: 1 in type t2.medium (should be at least 2.. for HA)
    - pod networking: calico
    - ssh key

command:

```jsx
kops create cluster \
--name kops.papavonning.com \
--zones us-east-1a \
--node-count 1 \
--state s3://kops-papavonning \
--ssh-public-key ~/.ssh/ansible.pub \
--discovery-store s3://oidc-papavonning \
--node-count 1 \
--node-size t2.medium \
--control-plane-count 1 \
--control-plane-size t2.medium \
--networking calico \
--network-cidr "10.5.0.0/16"
--yes
# --dry-run -o yaml

```

export the env variables

```jsx
export KOPS_STATE_STORE=s3://kops-papavonning
export NAME=kops.papavonning.com

```

## quick way to setup

```jsx
ansible-playbook kops.yml
```

## SSH to nodes

check all instance dns name:

```jsx
aws ec2 describe-instances --query "Reservations[].Instances[].[PublicDnsName]" --output text

## example to ssh into 
ssh ubuntu@ec2-44-201-193-27.compute-1.amazonaws.com

aws ec2 describe-instances \
    --filters "Name=tag:k8s.io/role/master,Values=1" "Name=tag:KubernetesCluster,Values=kops.papavonning.com" \
    --query "Reservations[].Instances[].[PublicDnsName]" \
    --output json | jq -r '.[] | select(.[0] != "") | .[]'
```

use script `inventory.sh`to update the inventory.ini file

## update cluster

### OIDC setup

```jsx
kubeAPIServer:
  oidcIssuerURL: https://api.kops.papavonning.com/openid
  oidcClientID: kops
```

authentication TokenWebhook Config file: (check this file as a validation.)

```jsx
/etc/kubernetes/aws-iam-authenticator/kubeconfig.yaml
```

## Clean up

```jsx
kops delete cluster kops.papavonning.com --state s3://kops-papavonning --yes
```