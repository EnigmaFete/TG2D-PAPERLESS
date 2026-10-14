# ==============================================================================
# TG2D MONOREPO — CONVENIENT RUNTIME SHORTCUTS
# ==============================================================================

.PHONY: help up down restart logs status website ged clean

help:
	@echo "Available commands for TG2D Ecosystem:"
	@echo "  make up          - Start both Website (port 8080) and Paperless GED (port 8001)"
	@echo "  make website     - Start only the TG2D Website container"
	@echo "  make ged         - Start only the Paperless-ngx GED stack"
	@echo "  make down        - Stop all containers"
	@echo "  make restart     - Restart all containers"
	@echo "  make logs        - Follow logs for all services"
	@echo "  make status      - Check status of running containers"

up:
	docker compose up -d

website:
	docker compose up -d website

ged:
	docker compose up -d broker db gotenberg tika webserver

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

status:
	docker compose ps
