up:
	@echo "Your Cluster starting lauching..."
	vagrant up
	sh ./scripts/up/kubectlConfig.sh

jenkinsci: up
	@echo "in building..."

destroy:
	@echo "Removing your Vitural Mathine...."
	vagrant destroy -f | true
	@echo "Done"