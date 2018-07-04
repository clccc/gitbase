# Package configuration
PROJECT = gitbase
COMMANDS = cmd/gitbase

# Including ci Makefile
CI_REPOSITORY ?= https://github.com/src-d/ci.git
CI_PATH ?= $(shell pwd)/.ci
CI_VERSION ?= v1

MAKEFILE := $(CI_PATH)/Makefile.main
$(MAKEFILE):
	git clone --quiet --branch $(CI_VERSION) --depth 1 $(CI_REPOSITORY) $(CI_PATH);

-include $(MAKEFILE)

# we still need to do this for windows
bblfsh-client:
	cd vendor/gopkg.in/bblfsh/client-go.v2 && make dependencies

dependencies: bblfsh-client

mysql-upgrade:
	go run tools/rev-upgrade/main.go -p "gopkg.in/src-d/go-mysql-server.v0" -r $(shell curl --silent "https://api.github.com/repos/src-d/go-mysql-server/commits/master" -H'Accept: application/vnd.github.VERSION.sha')
