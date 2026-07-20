#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variável importante:

systemd="$1"

# Inicia a análise e salva a análise feita em um arquivo txt para registrar

printf "${CIANO}%-35s %-10s %-10s %s${RESET}\n" "NOME" "STATUS" "SUB" "DESCRIÇÃO"
printf "${AMARELO}Iniciando a análise de serviços rodando...${RESET}\n"
sleep 1

printf "${CIANO}%-35s %-10s %-10s %s${RESET}\n" "NOME" "STATUS" "SUB" "DESCRIÇÃO"

systemctl list-units --type=service --state=running --no-legend | \
awk '{printf "%-35s %-10s %-10s %s\n", $1, $3, $4, substr($0, index($0,$5))}'
