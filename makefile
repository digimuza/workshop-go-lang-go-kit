TITLE=Go seed
ORG=awpc
NAME=be-keys-go
IMAGE_NAME=$(ORG)/$(NAME)

.SILENT:
help:
	echo
	echo "Title: $(TITLE)"
	echo "Image: $(IMAGE_NAME)"
	echo
	echo "  Commands: "
	echo
	echo "    help - show available commands"
	echo "    base - build base image"
	echo "    build - build builder image"
	echo "    dev - start clean development"
	echo "    dev-resume - resume development"
	echo "    dev-clean - clean development"
	echo "    test - run tests"
	echo "    publish - publish image"
	echo "    deps - Check if all dependencies required are installed"

base:
	sudo docker build --build-arg IMAGE_NAME=$(IMAGE_NAME) --build-arg NAME=$(NAME) -f docker/Dockerfile -t $(IMAGE_NAME):base .

build: base
	sudo docker build --build-arg IMAGE_NAME=$(IMAGE_NAME) -f docker/build/Dockerfile -t $(IMAGE_NAME):build .

test: build
	sudo docker build --build-arg IMAGE_NAME=$(IMAGE_NAME) -f docker/test/Dockerfile -t $(IMAGE_NAME):test .
	sudo docker run $(IMAGE_NAME):test

dev-build: dev-clean build
	sudo docker-compose -f docker/dev/docker-compose.yml pull
	sudo docker-compose -f docker/dev/docker-compose.yml build --build-arg IMAGE_NAME=$(IMAGE_NAME) app

dev-clean:
	sudo docker-compose -f docker/dev/docker-compose.yml rm -fsv || true
	sudo rm -rf platform/tmp

dev: dev-build dev-resume

dev-resume:
	sudo docker-compose -f docker/dev/docker-compose.yml up

publish: build
	sudo docker build --build-arg IMAGE_NAME=$(IMAGE_NAME) -f docker/prod/Dockerfile -t $(IMAGE_NAME):latest .
	sudo docker push $(IMAGE_NAME):latest

deps:
	echo "  Dependencies: "
	echo
	echo "    * docker $(shell which docker > /dev/null || echo '- \033[31mNOT INSTALLED\033[37m')"
	echo "    * docker-compose $(shell which docker-compose > /dev/null || echo '- \033[31mNOT INSTALLED\033[37m')"
	echo "    * go $(shell which go > /dev/null || echo '- \033[31mNOT INSTALLED\033[37m')"
	echo
