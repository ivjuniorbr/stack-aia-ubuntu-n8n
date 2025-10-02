# Stack AIA – Ubuntu MATE 24.04 (n8n + Worker, Postgres, Redis, Flowise, Evolution API, Ngrok)

Ambiente pronto para automações com **n8n**, **Flowise**, **Evolution API**, **Postgres**, **Redis**, **Ngrok** em **Docker Compose**.  
Documentado para **Ubuntu MATE 24.04 LTS** em máquina UEFI, com **SSH**, **VNC** e **AnyDesk**.

---

## Sumário
1. [Cenário e objetivo](#cenário-e-objetivo)  
2. [Requisitos](#requisitos)  
3. [Instalação do Ubuntu e UEFI](#instalação-do-ubuntu-e-uefi)  
4. [Pós-instalação essencial](#pós-instalação-essencial)  
5. [AnyDesk](#anydesk)  
6. [Docker e Docker Compose](#docker-e-docker-compose)  
7. [Estrutura do projeto](#estrutura-do-projeto)  
8. [Templates: `.env` e `docker-compose.yml`](#templates-env-e-docker-composeyml)  
9. [Criar pastas, permissões e subir](#criar-pastas-permissões-e-subir)  
10. [Testes de saúde e URLs](#testes-de-saúde-e-urls)  
11. [Firewall (UFW)](#firewall-ufw)  
12. [Acesso remoto: SSH, VNC, TightVNC](#acesso-remoto-ssh-vnc-tightvnc)  
13. [Problemas comuns e correções](#problemas-comuns-e-correções)  
14. [Diagnóstico rápido](#diagnóstico-rápido)  

---

## Cenário e objetivo
- Sistema: **Ubuntu MATE 24.04 LTS** (instalação limpa, UEFI nativo).  
- Serviços via Docker: **n8n** (+ worker), **Postgres**, **Redis**, **Flowise**, **Evolution API**, **Ngrok**.  
- Acesso remoto: **AnyDesk**, **SSH (PuTTY)** e **VNC (x11vnc + TightVNC)**.

---

## Requisitos
- Ubuntu MATE 24.04 LTS (64-bit), acesso sudo e internet.  
- Portas padrão: `5678` (n8n), `3030` (Flowise), `8080` (Evolution), `5432` (Postgres), `6379` (Redis), `5900` (VNC).

---

## Instalação do Ubuntu e UEFI
1. **Pendrive** com Rufus (Windows):  
   - ISO `ubuntu-mate-24.04.x-desktop-amd64.iso`  
   - **GPT** + **UEFI (não CSM)** + **FAT32**.
2. **BIOS/UEFI (HP/geral)**  
   - Modo: **Nativo do UEFI (sem CSM)**  
   - **OS Boot Manager** no topo  
   - **Custom Boot** desativado.
3. Se ao ligar pedir **F9** toda vez, ajuste no Ubuntu:
   ```bash
   sudo efibootmgr -v
   sudo efibootmgr -o 0000

   # Se necessário reinstalar GRUB EFI:
   sudo mount | grep /boot/efi || sudo mount /boot/efi
   sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu
   sudo update-grub
   sudo efibootmgr -o 0000

