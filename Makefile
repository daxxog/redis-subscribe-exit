.PHONY: help
help:
	@echo "available targets -->\n"
	@cat Makefile | grep ".PHONY" | grep -v ".PHONY: _" | sed 's/.PHONY: //g'


.PHONY: build-docker
build-docker:
	cat ./Dockerfile | \
	docker build -f - . -t daxxog/redis-subscribe-exit:latest


.PHONY: tag
tag: build-docker
	docker tag daxxog/redis-subscribe-exit:latest daxxog/redis-subscribe-exit:$$(cat BUILD_NUMBER)
	@echo docker tag daxxog/redis-subscribe-exit:latest daxxog/redis-subscribe-exit:$$(cat BUILD_NUMBER)


.PHONY: release
release: version-bump
	make tag
	docker push daxxog/redis-subscribe-exit:latest 
	docker push daxxog/redis-subscribe-exit:$$(cat BUILD_NUMBER)
	git add BUILD_NUMBER
	git commit -m "built redis-subscribe-exit@$$(cat BUILD_NUMBER)"
	git push
	git tag -a "$$(cat BUILD_NUMBER)" -m "tagging version $$(cat BUILD_NUMBER)"
	git push origin $$(cat BUILD_NUMBER)


.PHONY: version-bump
version-bump:
	dc --version
	touch BUILD_NUMBER
	echo "$$(cat BUILD_NUMBER) 1 + p" | dc | tee _BUILD_NUMBER
	mv _BUILD_NUMBER BUILD_NUMBER


.PHONY: debug-docker
debug-docker: build-docker
	docker run -i -t \
	-e REDIS_URL=redis://host.docker.internal \
	-e REDIS_CHANNEL=test \
	--entrypoint /bin/bash \
	daxxog/redis-subscribe-exit
