up:
	@echo "Your Cluster starting lauching..."
	vagrant up
	sh ./scripts/up/kubectlConfig.sh

jenkinsci:
	@echo "in building..."
	@echo "applying jenkins ci robot...."
	sh ./scripts/jenkinsci/configures.sh
	sh ./scripts/jenkinsci/install.sh

unjenkinsci:
	@echo "in reemoving jenkinsci..."
	@echo "applying jenkins ci robot...."
	sh ./scripts/jenkinsci/uninstall.sh

destroy:
	@echo "Removing your Vitural Mathine...."
	vagrant destroy -f | true
	@echo "Done"