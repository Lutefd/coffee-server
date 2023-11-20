include .env

stop_containers:
	@echo "Stopping other docker containers"
	@if [ $$(docker ps -q) ]; then \
		echo "found and stopped containers"; \
		docker stop $$(docker ps -q); \
	else \
		echo "no containers running"; \
	fi

create_container:
	@echo "Creating docker container"
	@docker run -d -p 8080:8080 --name $(DB_DOCKER_CONTAINER) -p ${DB_PORT}:${DB_PORT} -e POSTGRES_USER=${USER} -e POSTGRES_PASSWORD=${PASSWORD} -e POSTGRES_DB=${DB_NAME} postgres:12-alpine

create_db:
	@echo "Creating database"
	@docker exec -it $(DB_DOCKER_CONTAINER) createdb --username ${USER} --owner=${USER} ${DB_NAME}

start_containers:
	@echo "Starting docker containers"
	@docker start $(DB_DOCKER_CONTAINER)

create_migrations:
	sqlx migrate add init

run_migrations:
	sqlx migrate run --database-url "postgres://${USER}:${PASSWORD}@${HOST}:${DB_PORT}/${DB_NAME}?sslmode=disable"

rollback_migrations:
	sqlx migrate revert --database-url "postgres://${USER}:${PASSWORD}@${HOST}:${DB_PORT}/${DB_NAME}?sslmode=disable"