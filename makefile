add:
	@mv ./tmp/[1-3]-* .

run: add
	@terraform apply -auto-approve

cluster: run
	@kops create cluster \
		--name kops.papavonning.com \
		--kubernetes-version v1.27.5 \
		--zones us-east-1a,us-east-1b \
		--node-count 1 \
		--state s3://kops-papavonning \
		--ssh-public-key ~/.ssh/ansible.pub \
		--discovery-store s3://oidc-papavonning \
		--node-count 1 \
		--node-size t2.medium \
		--control-plane-count 1 \
		--control-plane-size t2.medium \
		--control-plane-zones us-east-1a \
		--networking calico \
		--network-cidr "10.5.0.0/16" \
		--yes


remove:
	@mv [1-3]-* ./tmp/

delete: remove
	@kops delete cluster kops.papavonning.com --state s3://kops-papavonning --yes

down: delete
	@terraform apply -auto-approve