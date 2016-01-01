SHELL=/bin/bash
BUCKET=assets.jjperezaguinaga.com
DOCKER=/usr/local/bin/docker

INDEX=./index.jjperezaguinaga.com

# Configurable variables
DIST=./dist
DOCKER-FILE=Dockerfile
DOCKER-REPO=jjperezaguinaga/assets

run-image: stop rm
	$(DOCKER) run -d -p 80:8080 --name assets $(DOCKER-REPO)

buildDocker:
	cp $(DOCKER-FILE) $(DIST)
	$(DOCKER) build -t=$(DOCKER-REPO) $(DIST)

buildAssets:
	mkdir -p $(DIST)/$(URL)/$(VERSION)
	cp -r $(PROJECT)/* $(DIST)/$(URL)/$(VERSION)

buildIndex:
	PROJECT=index.jjperezaguinaga.com URL=index VERSION=v1 make buildAssets

buildArticles:
	PROJECT=articles.jjperezaguinaga.com URL=articles VERSION=v1 make buildAssets

build: buildArticles buildIndex buildDocker

run: build run-image

stop:
	$(DOCKER) stop assets

rm:
	$(DOCKER) rm assets

ls:
	#Assumes aws-cli, AWS_ACCESS_KEY + AWS_SECRET_KEY
	aws s3 ls

uploadAssets:
	#Assumes aws-cli, AWS_ACCESS_KEY + AWS_SECRET_KEY
	aws s3 sync $(PROJECT) s3://$(BUCKET)/$(URL)/$(VERSION)/ --acl public-read --delete --region eu-central-1

syncArticleAssets:
	PROJECT=articles.jjperezaguinaga.com URL=articles VERSION=v1 make uploadAssets

syncMainAssets:
	PROJECT=index.jjperezaguinaga.com URL=index VERSION=v1 make uploadAssets

downloadAll:
	aws s3 cp s3://$(BUCKET) . --recursive

sync: syncArticleAssets syncMainAssets
