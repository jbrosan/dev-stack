# Makefile for local dev stack:
# PostgreSQL + Dragonfly + pgAdmin + RedisInsight

# You can override these on the command line if you want, e.g.:
# make up COMPOSE="docker-compose"
COMPOSE ?= docker compose

# Default target
.PHONY: help
help:
	@echo "Dev Stack Makefile"
	@echo
	@echo "Usage:"
	@echo "  make up            - Start all services in the background"
	@echo "  make down          - Stop all services (keep volumes)"
	@echo "  make down-v        - Stop all services and remove volumes (NUKE DATA)"
	@echo "  make restart       - Restart all services"
	@echo "  make ps            - Show service status"
	@echo "  make logs          - Tail logs for all services"
	@echo "  make logs-postgres - Tail logs for Postgres"
	@echo "  make logs-dragonfly - Tail logs for Dragonfly"
	@echo "  make logs-pgadmin  - Tail logs for pgAdmin"
	@echo "  make logs-redisinsight - Tail logs for RedisInsight"
	@echo "  make psql          - Open psql into the default database"
	@echo "  make redis-cli     - Open redis-cli connected to Dragonfly"

.PHONY: up
up:
	$(COMPOSE) up -d

.PHONY: down
down:
	$(COMPOSE) down

.PHONY: down-v
down-v:
	$(COMPOSE) down -v

.PHONY: restart
restart: down up

.PHONY: ps
ps:
	$(COMPOSE) ps

.PHONY: logs
logs:
	$(COMPOSE) logs -f

.PHONY: logs-postgres
logs-postgres:
	docker logs -f dev-postgres

.PHONY: logs-dragonfly
logs-dragonfly:
	docker logs -f dev-dragonfly

.PHONY: logs-pgadmin
logs-pgadmin:
	docker logs -f dev-pgadmin

.PHONY: logs-redisinsight
logs-redisinsight:
	docker logs -f dev-redisinsight

# Convenience commands assuming:
# - psql is installed on your host
# - redis-cli is installed on your host
# They read connection info from .env if present, or fall back to defaults.

.PHONY: psql
psql:
	@# Load env vars if .env exists
	@if [ -f .env ]; then set -a && . ./.env && set +a; fi; \
	PGUSER="$${POSTGRES_USER:-app_user}"; \
	PGPASS="$${POSTGRES_PASSWORD:-change_me}"; \
	PGDB="$${POSTGRES_DB:-app_dev}"; \
	PGPORT="$${POSTGRES_PORT:-5432}"; \
	echo "Connecting to postgres://$$PGUSER:*****@localhost:$$PGPORT/$$PGDB"; \
	PGPASSWORD="$$PGPASS" psql -h localhost -p "$$PGPORT" -U "$$PGUSER" "$$PGDB"

.PHONY: redis-cli
redis-cli:
	@if [ -f .env ]; then set -a && . ./.env && set +a; fi; \
	RPORT="$${DRAGONFLY_PORT:-6379}"; \
	echo "Connecting to Dragonfly at localhost:$$RPORT"; \
	redis-cli -h localhost -p "$$RPORT"
