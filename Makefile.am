
.PHONY: deb debug docker docker-push

# Відображення інформації про пакет
debug:
	@echo "Package: $(PACKAGE)"
	@echo "Version: $(VERSION)"

# Побудова DEB-пакету
deb:
	@echo "Building DEB package..."
	dpkg-deb --build deb
	echo Maintainer: $(PACKAGE_BUGREPORT) >> $(CTRLF_NAME)
	echo -n "Description: " >> $(CTRLF_NAME)
	echo "calculation software" >> $(CTRLF_NAME)
	make DESTDIR=$(CURDIR)/deb install
	@echo "Creating Docker image..."
	make docker

# Генерація Dockerfile та побудова Docker-образу
docker:
	@echo "Building Docker image..."
	echo "FROM ubuntu:latest" > Dockerfile
	echo "MAINTAINER $(PACKAGE_BUGREPORT)" >> Dockerfile
	echo "COPY deb /opt/$(PACKAGE)" >> Dockerfile
	echo "RUN apt-get update && apt-get install -y ./opt/$(PACKAGE)" >> Dockerfile
	echo "ENTRYPOINT [\"/opt/$(PACKAGE)/bin/program\"]" >> Dockerfile
	docker build -t $(PACKAGE):$(VERSION) .

# Завантаження Docker-образу в DockerHub
docker-push:
	@echo "Pushing Docker image to DockerHub..."
	@if [ -z "$(DOCKER_USER)" ] || [ -z "$(DOCKER_PASS)" ]; then \
    echo "Please set DOCKER_USER and DOCKER_PASS environment variables"; \
    exit 1; \
  fi
	echo "$(DOCKER_PASS)" | docker login -u "$(DOCKER_USER)" --password-stdin
	docker tag $(PACKAGE):$(VERSION) $(DOCKER_USER)/$(PACKAGE):$(VERSION)
	docker push $(DOCKER_USER)/$(PACKAGE):$(VERSION)
	docker logout


