# Makefile

SHARELATEX_TAG ?= consorziorfx/sharelatex:latest

TAG_NAME    = $(firstword $(subst :, ,$(SHARELATEX_TAG)))
TAG_VERSION = $(lastword $(subst :, ,$(SHARELATEX_TAG)))

export TAG_NAME \
       TAG_VERSION

PERL = perl

## PERL ##
__ax_pl_envsubst = $(PERL) -pe 's/([^\\]|^)\$$\{([a-zA-Z_][a-zA-Z_0-9]*)\}/$$1.$$ENV{$$2}/eg' < $1 |\
                   $(PERL) -pe 's/\\\$$/\$$/g' > $2

.PHONY: Dockerfile Dockerfile-base
Dockerfile: Dockerfile.template
	@ $(call __ax_pl_envsubst,$<,$@);

Dockerfile-base: Dockerfile-base.template
	@ $(call __ax_pl_envsubst,$<,$@);


build-base: Dockerfile-base
	docker build -f $< -t $(TAG_NAME)-base .

build-community: Dockerfile
	docker build -f $< -t $(TAG_NAME) .


push:
	docker push $(TAG_NAME)-base:latest;
	docker push $(TAG_NAME):latest;


PHONY: build-base build-community
