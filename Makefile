SHELL=/bin/bash
BUCKET=assets.jjperezaguinaga.com

#Assumes aws-cli, AWS_ACCESS_KEY + AWS_SECRET_KEY

uploadAssets:
	aws s3 sync $(PROJECT) s3://$(BUCKET)/$(URL)/$(VERSION)/ --acl public-read --delete

syncArticleAssets:
	PROJECT=articles.jjperezaguinaga.com URL=articles VERSION=v1 make uploadAssets

syncMainAssets:
	PROJECT=index.jjperezaguinaga.com URL=index VERSION=v1 make uploadAssets

sync: syncArticleAssets syncMainAssets
