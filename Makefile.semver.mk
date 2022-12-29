##
# WARNING: do not track this file in your VCS, to edit check out:
# 
# <https://github.com/g3w-suite/makefiles/Makefile.semver.mk>
##
# USAGE: include it your main Makefile as follows:
##
# install: Makefile.semver.mk
#
# Makefile.semver.mk:
# 	wget https://raw.githubusercontent.com/g3w-suite/makefiles/master/$@
#
# include Makefile.semver.mk
##

ROOT_DIR ?=        $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CURRENT_VERSION ?= $(shell git tag --sort=v:refname | tail -1 | sed 's/^v//' )
PROJECT_NAME ?=    $(notdir $(CURDIR))

##
# Do nothing when `make' is run without args.
##
default:
	@:

##
# Add new git version:
#
# make version [ v=X.Y.Z ] [ stage=alpha|beta ]
##
version:
	@set -e ;\
		NEW_VERSION=$$( [ -n "$$v" ] && echo "v"$${v#v} || echo $$NEW_VERSION ) ;\
		echo "v$(CURRENT_VERSION)" ;\
		echo "$$NEW_VERSION" ;\
		if [ -n "$$NEW_VERSION" ]; then \
			$(MAKE) --no-print-directory readme-version v=$$NEW_VERSION ;\
		fi ;\
		git add -A ;\
		git commit -m "$$NEW_VERSION" ;\
		git tag $$NEW_VERSION

##
# Bump major:
#
# X.Y.Z --> X+1.0.0
##
version-major:
	@set -e ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="."}{ print "v"$$1+1, 0, 0 }' )

##
# Bump minor:
#
# X.Y.Z --> X.Y+1.0
##
version-minor:
	@set -e ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="."}{ print "v"$$1, $$2+1, 0 }' )

##
# Bump patch:
#
# X.Y.Z --> X.Y.Z+1
##
version-patch:
	@set -e ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="."}{ gsub(/[^0-9]+/, "", $$3); print "v"$$1, $$2, $$3+1 }' )

##
# Bump alpha:
#
# X.Y.Z-alpha.rev --> X.Y.Z-alpha.rev+1
#
# make alpha [ v=X.Y.Z ]
##
version-alpha:
	@set -e ;\
		CURRENT_VERSION=$$( [ -n "$$v" ] && echo "v"$${v#v} || echo $$CURRENT_VERSION ) ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="-"}{ gsub(/[^0-9]+/, "", $$2); print "v"$$1, "alpha."($$2 == "" ? 0 : $$2+1) }' )

##
# Bump beta:
#
# X.Y.Z-beta.rev --> X.Y.Z-beta.rev+1
#
# make beta [ v=X.Y.Z ]
##
version-beta:
	@set -e ;\
		CURRENT_VERSION=$$( [ -n "$$v" ] && echo "v"$${v#v} || echo $$CURRENT_VERSION ) ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="-"}{ gsub(/[^0-9]+/, "", $$2); print "v"$$1, "beta."($$2 == "" ? 0 : $$2+1) }' )

##
# Purge local git tags (remote --> local)
##
prune-tags:
	git fetch --prune origin "+refs/tags/*:refs/tags/*"
	@echo -e '\nLocal tags deleted\n'

##
# Update remote git tags (local --> remote)
##
push-tags:
	git push
	git push --tags
	@echo -e '\nRemote tags updated\n'

##
# Update readme version
#
# make readme [ v=X.Y.Z ]
##
readme-version:
	@sed -i "1c\\# $(PROJECT_NAME) $(v)" $(ROOT_DIR)/README.md
	@echo -e '\nReadme heading updated: # $(PROJECT_NAME) $(v)\n'