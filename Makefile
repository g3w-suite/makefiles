##
# Makefile
##

PROJECT_NAME = makefiles
PKG_NAME = makefiles

default: list-tasks

##
# Get a list of tasks when `make' is run without args.
#
# https://stackoverflow.com/a/26339924
##
list-tasks:
	@echo Available tasks:
	@echo ----------------
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo

include Makefile.semver.mk
include Makefile.venv.mk