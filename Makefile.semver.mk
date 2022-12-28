##
# Makefile.semver.mk
##

##
# install: Makefile.semver.mk
#
# Makefile.semver.mk:
# 	wget https://raw.githubusercontent.com/g3w-suite/makefiles/master/$@
#
# include Makefile.semver.mk
##

ROOT_DIR ?=             $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
CURRENT_VERSION ?=      $(shell git tag --sort=v:refname | tail -1 | sed 's/^v//' )
README_PROJECT_TITLE ?= $(notdir $(CURDIR))

##
# Do nothing when `make' is run without args.
##
default:

##
# Bump major:
#
# X.Y.Z --> X+1.0.0
##
major:
	@set -e ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="."}{ print "v"$$1+1, 0, 0 }' )

##
# Bump minor:
#
# X.Y.Z --> X.Y+1.0
##
minor:
	@set -e ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="."}{ print "v"$$1, $$2+1, 0 }' )

##
# Bump patch:
#
# X.Y.Z --> X.Y.Z+1
##
patch:
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
alpha:
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
beta:
	@set -e ;\
		CURRENT_VERSION=$$( [ -n "$$v" ] && echo "v"$${v#v} || echo $$CURRENT_VERSION ) ;\
		$(MAKE) --no-print-directory \
			version NEW_VERSION=$$( echo $(CURRENT_VERSION) | awk 'BEGIN{FS=OFS="-"}{ gsub(/[^0-9]+/, "", $$2); print "v"$$1, "beta."($$2 == "" ? 0 : $$2+1) }' )

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
		$(MAKE) --no-print-directory preversion v=$$NEW_VERSION ;\
		git add -A ;\
		git commit -m "$$NEW_VERSION" ;\
		git tag $$NEW_VERSION ;\
		$(MAKE) --no-print-directory postversion v=$$NEW_VERSION

preversion:
	@set -e ;\
		if [ -n "$$v" ]; then \
			$(MAKE) --no-print-directory readme v=$$v ;\
		fi

postversion:
	@set -e ;\
		git push ;\
		$(MAKE) --no-print-directory push-tags

##
# Update remote git tags (local --> remote)
##
push-tags:
	git push --tags
	@echo -e '\nRemote tags updated\n'

##
# Purge local git tags (remote --> local)
##
prune-tags:
	git fetch --prune origin "+refs/tags/*:refs/tags/*"
	@echo -e '\nLocal tags deleted\n'

##
# Update readme version
#
# make readme [ v=X.Y.Z ]
##
readme:
	@sed -i "1c\\# $(README_PROJECT_TITLE) $(v)" $(ROOT_DIR)/README.md
	@echo -e '\nReadme heading updated: # $(README_PROJECT_TITLE) $(v)\n'