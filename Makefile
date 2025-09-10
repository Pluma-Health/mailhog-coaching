.PHONY: install build helm-template-all

build:
	docker build -t mailhog-coaching .


install:
	cd app && npm install




helm-template-all:
	@for profile in $$(ls deployment/profiles/); do \
		mkdir -p manifests/$$profile; \
		helm template mailhog-coaching deployment/ \
			-f deployment/profiles/$$profile/values.yaml \
			--output-dir manifests/$$profile; \
	done