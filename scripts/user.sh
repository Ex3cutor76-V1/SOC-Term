#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis importantes

humano=$(awk -F: '$3 >= 1000 && $1 != "nobody" {
printf "%-20s %-8s %-20s %-20s\n",$1,$3,$6,$7
}' /etc/passwd)

servico=$(awk -F: '$3 < 1000 && $1 != "nobody" {
printf "%-20s %-8s %-20s %-20s\n",$1,$3,$6,$7
}' /etc/passwd)

linha="=============================="

humanos_total=$(printf "%s\n" "$humano" | grep -c .)

servicos_total=$(printf "%s\n" "$servico" | grep -c .)

# Análises

# Análise de usuários humanos
printf "${MAGENTA}Usuários humanos:${RESET}\n"
echo "$linha"
echo "$humano"

# Analise de usuários de serviços/sistema
printf "${MAGENTA}Usuários de sistema e serviços:${RESET}\n"
echo "$linha"
echo "$servico"
echo "$linha"

# Total de usuários encontrados
printf "${MAGENTA}Total:${RESET}\n"
printf "Usuários humanos: %s\n" "$humanos_total"
printf "Contas de sistema: %s\n" "$servicos_total"
