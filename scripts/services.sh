#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis importantes
quantidade=$(systemctl list-units --type=service --state=running --no-legend | grep -c ".service")

# Inicia a análise e salva a análise feita em um arquivo txt para registrar

printf "${AMARELO}Iniciando a análise de serviços rodando...${RESET}\n"
sleep 1

printf "${CIANO}%-35s %-10s %-10s %s${RESET}\n" "NOME" "STATUS" "BOOT" "DESCRIÇÃO"


systemctl list-units --type=service --state=running --no-legend | \
while read -r service load active sub description; do

    boot=$(systemctl is-enabled "$service" 2>/dev/null)

    printf "%-35s %-10s %-10s %s\n" "$service" "$active" "$boot" "$description"

done

printf "${MAGENTA}Total de serviços ativos: ${RESET}$quantidade\n"

