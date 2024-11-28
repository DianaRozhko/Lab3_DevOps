PACKAGE = program
VERSION = 1.0
PACKAGE_BUGREPORT = rozhko.diana06@gmail.com

AUTOMAKE_OPTIONS = foreign subdir-objects

# Основні програми та тести
bin_PROGRAMS = program
program_SOURCES = main.cpp func.cpp

check_PROGRAMS = test_program
test_program_SOURCES = test_func.cpp func.cpp

# Ціль для створення Docker-образу
docker: dockerfile docker-build

# Створення Dockerfile для побудови образу
dockerfile:
	@echo "Generating Dockerfile..."
	@echo "FROM ubuntu:latest" > Dockerfile
	@echo "MAINTAINER $(PACKAGE_BUGREPORT)" >> Dockerfile
	@echo "COPY deb /opt/$(PACKAGE)" >> Dockerfile
	@echo "RUN apt-get update && apt-get install -y /opt/$(PACKAGE)" >> Dockerfile
	@echo "ENTRYPOINT [\"/opt/$(PACKAGE)/bin/program\"]" >> Dockerfile

# Побудова Docker-образу
docker-build:
	@echo "Building Docker image $(PACKAGE):$(VERSION)..."
	docker build -t $(PACKAGE):$(VERSION) .

# Ціль для пушу Docker-образу до DockerHub
docker-push:
	@echo "Pushing Docker image to DockerHub..."
	@if [ -z "$(DOCKER_USER)" ] || [ -z "$(DOCKER_PASS)" ]; then \
		echo "Please set DOCKER_USER and DOCKER_PASS environment variables."; \
		exit 1; \
	fi
	@echo "$(DOCKER_PASS)" | docker login -u "$(DOCKER_USER)" --password-stdin
	@docker tag $(PACKAGE):$(VERSION) $(DOCKER_USER)/$(PACKAGE):$(VERSION)
	@docker push $(DOCKER_USER)/$(PACKAGE):$(VERSION)
	@docker logout

# Очищення Docker-образу після завершення роботи
docker-clean:
	@echo "Cleaning up Docker images..."
	@docker rmi $(PACKAGE):$(VERSION)

# Інші мети
install:  # Мета для встановлення програми
	make DESTDIR=$(CURDIR)/deb install

