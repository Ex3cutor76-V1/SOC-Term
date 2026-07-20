#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis importantes

port="$1"
linha="====================================================================================================================================="

# Inicio do script

printf "${AMARELO}Iniciando a análise de portas abertas...${RESET}\n"
sleep 1

echo "$linha"
printf "${CIANO}TCP:${RESET}\n"
ss -tunp
echo "$linha"

echo "$linha"
printf "${CIANO}UDP:${RESET}\n"
ss -ulpn
echo "$linha"
