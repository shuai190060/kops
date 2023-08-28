#!/bin/bash

INVENTORY_FILE="inventory.ini"

echo "" > $INVENTORY_FILE


# Fetch the control plane details
CONTROL_PLANE_INSTANCES=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/role/master,Values=1" "Name=tag:KubernetesCluster,Values=kops.papavonning.com" --query "Reservations[].Instances[].[PublicDnsName]" --output json)

# Parse the control plane instances and write to inventory
echo "" >> $INVENTORY_FILE
echo "[control_plane]" >> $INVENTORY_FILE
COUNTER=1
echo "$CONTROL_PLANE_INSTANCES" | jq -r '.[] | select(.[0] != "") |.[]' | while read line; do
  echo "control-plane-$COUNTER ansible_host=$line ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible" >> $INVENTORY_FILE
  let COUNTER++
done



# Fetch the worker node details
WORKER_INSTANCES=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/role/node,Values=1" "Name=tag:KubernetesCluster,Values=kops.papavonning.com" --query "Reservations[].Instances[].[PublicDnsName]" --output json)

# Parse the worker instances and write to inventory
echo "[worker_node]" >> $INVENTORY_FILE
COUNTER=1
echo "$WORKER_INSTANCES" | jq -r '.[] | select(.[0] != "") |.[]' | while read line; do
  echo "node-$COUNTER ansible_host=$line ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/ansible" >> $INVENTORY_FILE
  let COUNTER++
done


