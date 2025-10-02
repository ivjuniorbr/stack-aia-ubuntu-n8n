---
title: Stack AIA (Ubuntu MATE 24.04)
---

# Stack AIA — Documentação

Infra Docker com **n8n + Worker, Postgres, Redis, Flowise, Evolution API, Ngrok** no **Ubuntu MATE 24.04**.

## 🚀 Guia rápido
```bash
# Host
sudo apt update && sudo apt upgrade -y
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Projeto
sudo mkdir -p /opt/stack-aia && sudo chown -R $USER:$USER /opt/stack-aia
cd /opt/stack-aia
git clone https://github.com/ivjuniorbr/stack-aia-ubuntu-n8n.git .
cp .env.example .env   # preencha os placeholders
sudo mkdir -p /opt/stack-aia/{n8n,_wf,_cred,postgres/data,redis,flowise,evolution}
sudo chown -R 1000:1000 /opt/stack-aia/n8n /opt/stack-aia/_wf /opt/stack-aia/_cred
docker compose pull && docker compose up -d

## 🔌 Portas e serviços
- **n8n:** `http://HOST:5678`
- **Flowise:** `http://HOST:3030`
- **Evolution:** `http://HOST:8080`

## ✅ Healthchecks
```bash
curl -fsS http://localhost:5678/healthz && echo
curl -I http://localhost:3030
curl -I http://localhost:8080
