#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis
log="$1"
LOG_DIR="/opt/SOC-Term/logs"

# Flags
case "$log" in

# Flag para análise de logs envolvendo SSH
-ssh)
sudo journalctl _SYSTEMD_UNIT=ssh.service --no-pager -n 1000 > "$LOG_DIR/log-ssh-$(date +%F-%H%M).txt" 2>/dev/null || \
sudo journalctl _SYSTEMD_UNIT=sshd.service --no-pager -n 1000 > "$LOG_DIR/log-ssh-$(date +%F-%H%M).txt"
if [ $? -ne 0 ]; then
    printf "${VERMELHO}Falha ao coletar log.${RESET}\n"
    exit 1
fi
chmod 600 "$LOG_DIR/log-ssh-*.txt"
printf "${CIANO}Log salva, use: sct --log${RESET}\n"
;;

# Flag para análise de logs envolvendo o sistema
-sys)
sudo journalctl -p 3..4 --no-pager -n 200 | grep -v "UFW BLOCK" > "$LOG_DIR/log-sys-$(date +%F-%H%M).txt"
if [ $? -ne 0 ]; then
    printf "${VERMELHO}Falha ao coletar log.${RESET}\n"
    exit 1
fi
chmod 600 "$LOG_DIR/log-sys-*.txt"
printf "${CIANO}Log salva, use: sct --log${RESET}\n"
;;

# Flag para análise de logs envolvendo serviços
-svc)
sudo journalctl -p 3 --since "1 hour ago" --no-pager > "$LOG_DIR/log-svc-$(date +%F-%H%M).txt"
if [ $? -ne 0 ]; then
    printf "${VERMELHO}Falha ao coletar log.${RESET}\n"
    exit 1
fi
chmod 600 "$LOG_DIR/log-svc-*.txt"
printf "${CIANO}Log salva, use: sct --log${RESET}\n"
;;

# Flag para análise de logs envolvendo o Kernel
-krn)
sudo dmesg -T --level=err,warn | tail -n 500 > "$LOG_DIR/log-krn-$(date +%F-%H%M).txt"
if [ $? -ne 0 ]; then
    printf "${VERMELHO}Falha ao coletar log.${RESET}\n"
    exit 1
fi
chmod 600 "$LOG_DIR/log-krn-*.txt"
printf "${CIANO}Log salva, use: sct --log${RESET}\n"
;;

# Flag inválida
*)
printf "${VERMELHO}Flag inválida${RESET}\n"
;;

esac
