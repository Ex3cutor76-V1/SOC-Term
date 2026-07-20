#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis
log="$1"

# Flags
case "$log" in

# Flag para análise de logs envolvendo SSH
-ssh)
sudo journalctl _SYSTEMD_UNIT=ssh.service --no-pager -n 1000 > log-ssh-$(date +%F-%H%M).txt 2>/dev/null || \
sudo journalctl _SYSTEMD_UNIT=sshd.service --no-pager -n 1000 > llog-ssh-$(date +%F-%H%M).txt
printf "${CIANO}Salvo em log-ssh.txt${RESET}\n"
;;

# Flag para análise de logs envolvendo o sistema
-sys)
sudo journalctl -p 3..4 --no-pager -n 200 | grep -v "UFW BLOCK" > log-sys-$(date +%F-%H%M).txt
printf "${CIANO}Salvo em log-sys.txt${RESET}\n"
;;

# Flag para análise de logs envolvendo serviços
-svc)
sudo journalctl -p 3 --since "1 hour ago" --no-pager > log-svc-$(date +%F-%H%M).txt
printf "${CIANO}Salvo em log-svc.txt${RESET}\n"
;;

# Flag inválida
*)
printf "${VERMELHO}Flag inválida${RESET}\n"
;;

esac
