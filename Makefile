# ========= Stack AIA – atalhos Docker Compose =========
# Uso rápido:
#   make up        -> sobe a stack
#   make down      -> derruba a stack
#   make pull      -> atualiza as imagens
#   make recreate  -> re-cria containers (sem perder dados)
#   make logs      -> logs de todos os serviços (follow)
#   make logs-n8n  -> logs do serviço n8n (follow)
#   make ps        -> status dos containers
#   make restart   -> reinicia todos os serviços
#   make prune     -> limpa imagens/volumes órfãos (cuidado)
#   make health    -> checa n8n/Flowise/Evolution em localhost
#   make init-dirs -> cria pastas e ajusta permissões pro n8n

SHELL := /bin/bash
DC := docker compose
UID_GUEST := 1000
GID_GUEST := 1000

# Se precisar, ajuste as portas aqui (devem bater com seu .env / compose)
PORT_N8N      ?= 5678
PORT_FLOWISE  ?= 3030
PORT_EVOL     ?= 8080

.DEFAULT_GOAL := help

.PHONY: help up down restart ps logs pull build recreate prune health logs-n8n logs-flowise logs-evolution init-dirs

help:
	@echo "Comandos disponíveis:"
	@echo "  make up         -> sobe a stack em modo daemon"
	@echo "  make down       -> derruba a stack"
	@echo "  make restart    -> reinicia todos os serviços"
	@echo "  make ps         -> mostra status dos containers"
	@echo "  make logs       -> logs de todos os serviços (follow)"
	@echo "  make logs-n8n   -> logs do n8n (follow)"
	@echo "  make logs-flowise   -> logs do Flowise (follow)"
	@echo "  make logs-evolution -> logs do Evolution API (follow)"
	@echo "  make pull       -> atualiza imagens (pull)"
	@echo "  make build      -> build com --pull"
	@echo "  make recreate   -> recria containers (sem perder dados)"
	@echo "  make prune      -> docker system prune -f (cuidado)"
	@echo "  make health     -> checa http://localhost:$(PORT_N8N),:$(PORT_FLOWISE),:$(PORT_EVOL)"
	@echo "  make init-dirs  -> cria pastas e ajusta permissões para n8n"

up:
	$(DC) up -d

down:
	$(DC) down

restart:
	$(DC) restart || ( $(DC) down && $(DC) up -d )

ps:
	$(DC) ps

logs:
	$(DC) logs -f --tail=100

logs-n8n:
	$(DC) logs -f --tail=200 n8n

logs-flowise:
	$(DC) logs -f --tail=200 flowise

logs-evolution:
	$(DC) logs -f --tail=200 evolution

pull:
	$(DC) pull

build:
	$(DC) build --pull

recreate:
	$(DC) up -d --force-recreate

prune:
	docker system prune -f

health:
	@echo "n8n     -> http://localhost:$(PORT_N8N)"
	@echo "Flowise -> http://localhost:$(PORT_FLOWISE)"
	@echo "EvolAPI -> http://localhost:$(PORT_EVOL)"
	@bash -c 'set -e; \
	  curl -fsS http://localhost:$(PORT_N8N)/healthz >/dev/null && echo "n8n OK"; \
	  curl -fsSI http://localhost:$(PORT_FLOWISE) >/dev/null && echo "Flowise OK"; \
	  curl -fsSI http://localhost:$(PORT_EVOL) >/dev/null && echo "Evolution OK"'

# criação de diretórios de dados + permissões para o usuário 1000 (n8n)
init-dirs:
	@sudo mkdir -p /opt/stack-aia/{n8n,_wf,_cred,postgres/data,redis,flowise,evolution}
	@sudo chown -R $(UID_GUEST):$(GID_GUEST) /opt/stack-aia/n8n /opt/stack-aia/_wf /opt/stack-aia/_cred
	@echo "Pastas criadas e permissões ajustadas."
