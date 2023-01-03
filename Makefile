##
# Makefile
##

PROJECT_NAME = makefiles
PKG_NAME = makefiles
PKG_DESC = A collection of reusable makefiles and tasks designed to make managing your python and docker projects easier.

##
# Get a list of tasks when `make` is run without args.
##
default: list-tasks
help: list-tasks

##
# Print a list of available tasks
#
# https://stackoverflow.com/a/26339924
##
list-tasks:
	@echo Available tasks:
	@echo ----------------
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo

include Makefile.semver.mk
include Makefile.venv.mk