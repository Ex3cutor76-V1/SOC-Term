#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variável importante
LIMIT=17

# Variável para a captura dos processos rodando

processos=$(ps aux --sort=-%cpu | grep -v "ps aux" | head -n "$LIMIT" | awk '{printf "%-15s %-8s %-8s %-8s %s\n", $1, $3, $4, $2, $11}')

# Mostra na tela e salva em um arquivo
printf "${AMARELO}Analisando processos..${RESET}\n"
sleep 1

printf "${MAGENTA}Processos sendo executados${RESET}\n"

echo "$processos"
