add:
	@mv ./tmp/[1-3]-* .

run: add
	@terraform apply -auto-approve

remove:
	@mv [1-3]-* ./tmp/

delete: remove
	@kops delete cluster kops.papavonning.com --state s3://kops-papavonning --yes