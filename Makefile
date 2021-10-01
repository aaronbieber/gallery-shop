uid := $(shell id -u)
gid := $(shell id -g)

.PHONY: build

build:
	cp -v Gemfile.sample Gemfile && \
	cp -v Gemfile.lock.sample Gemfile.lock && \
	chmod a+w * && \
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	docker-compose run --no-deps web rails new . --force --database=postgresql && \
	docker-compose build \
                       --build-arg UID=${uid} \
                       --build-arg GID=${gid} && \
	cp -v database.yml.sample config/database.yml

createdb:
	docker-compose run web rake 'db:create'

# todo: this is super destructive; it deletes ALL images/containers on the system!
#       probably make it not do that
clean:
	docker container ls -aq | xargs docker container rm && \
	docker image ls -aq | xargs docker image rm
