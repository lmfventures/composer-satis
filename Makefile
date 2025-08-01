.PHONY: build clean deploy

# Build the composer repository
build:
	php bin/satis build satis.json public/

# Clean generated files
clean:
	rm -rf public/

# Deploy to gh-pages branch
deploy: build
	git checkout -b gh-pages || git checkout gh-pages
	git rm -rf .
	cp -r public/* .
	git add .
	git commit -m "Update composer repository"
	git push origin gh-pages --force
	git checkout main
	git branch -D gh-pages

# Install dependencies
install:
	composer install --no-dev --optimize-autoloader

# Update dependencies (if needed)
update:
	composer update --no-dev

# Full build and deploy
all: install build deploy 