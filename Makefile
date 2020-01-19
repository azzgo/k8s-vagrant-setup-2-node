up:
	@echo "Your Cluster starting lauching..."
	vagrant up
	sh ./scripts/up/kubectlConfig.sh

jenkinsci:
	@echo "in building..."
	@echo "applying jenkins ci robot...."
	sh ./scripts/jenkinsci/install.sh
	@echo "After auto building you can try to access jenkins via http://jenkins.192-168-33-10.nip.io"
	@echo "Application will deployed at http://fox-web.192-168-33-10.nip.io"

unjenkinsci:
	@echo "in reemoving jenkinsci..."
	@echo "applying jenkins ci robot...."
	sh ./scripts/jenkinsci/uninstall.sh

destroy:
	@echo "Removing your Vitural Mathine...."
	vagrant destroy -f | true
	@echo "Done"