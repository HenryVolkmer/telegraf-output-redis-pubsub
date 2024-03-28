include .env

.PHONY: up-common up up-build down stop prune ps shell logs mutagen composer console phpunit cmd

default: up

## help :       Print commands help.
help : Makefile
	@sed -n 's/^##//p' $<

up-common:
	@echo "Starting up containers for for $(PROJECT_NAME)..."
	docker-compose pull

## up   :       Start up containers.
up: up-common
	docker-compose up -d --remove-orphans

## up-build:    Start containers with rebuilding images.
up-build: up-common
	docker-compose up -d --build --remove-orphans

## down :       Stop containers.
down: stop

## start        :       Start containers without updating.
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	@docker-compose start

## stop :       Stop containers.
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose stop

## prune        :       Remove containers and their volumes.
##              You can optionally pass an argument with the service name to prune single container
##              prune mariadb   : Prune `mariadb` container and remove its volumes.
##              prune mariadb solr      : Prune `mariadb` and `solr` containers and remove their volumes.
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose down -v $(filter-out $@,$(MAKECMDGOALS))

## ps   :       List running containers.
ps:
	@docker ps --filter name='$(PROJECT_NAME)*'

## shell        :       Access `php` container via shell.
##              You can optionally pass an argument with a service name to open a shell on the specified container
shell:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)_$(or $(filter-out $@,$(MAKECMDGOALS)), 'php')' --format "{{ .ID }}") sh


## phpunit:     Run PHPUnit in PHP container.
##              To avoid treating command arguments as make targets, place additional double dash before the argument list.
##              phpunit
##              phpunit -- --version
tests:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)_php' --format "{{ .ID }}") ./vendor/bin/phpunit -c phpunit.xml.dist --testsuite app

## cmd  :       Run arbitrary command in PHP container.
##              To avoid treating command arguments as make targets, place additional double dash before the argument list.
##              cmd -- php --version
cmd:
	docker exec -ti -e COLUMNS=$(shell tput cols) -e LINES=$(shell tput lines) $(shell docker ps --filter name='$(PROJECT_NAME)_php' --format "{{ .ID }}") $(filter-out $@,$(MAKECMDGOALS))

## logs :       View containers logs.
##              You can optinally pass an argument with the service name to limit logs
##              logs php        : View `php` container logs.
##              logs nginx php  : View `nginx` and `php` containers logs.
logs:
	@docker-compose logs -f $(filter-out $@,$(MAKECMDGOALS))

build:
	go build -o /tmp/input_plugin cmd/generator/main.go
	@echo "/tmp/input_plugin compiled"
	go build -o /tmp/output_plugin cmd/pubsub/main.go
	@echo "/tmp/output_plugin compiled"

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
