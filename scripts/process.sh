#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variável para a captura dos processos executados

analise=$(ps aux --sort=-%cpu | head -n 13 | awk '{printf "%-8s %-6s %-6s %s\n", $3, $4, $2, $11}')

# Mostra na tela e salva em um arquivo
printf "${AMARELO}Analisando processos..${RESET}\n"
sleep 1

printf "${MAGENTA}Processos sendo executados${RESET}\n"

echo "$analise"
echo "$analise" > process.txt

printf "${CIANO}Processos salvos em process.txt${RESET}\n"
