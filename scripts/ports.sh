#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis importantes
linha=$(printf '=%.0s' {1..142})
tcp=$(ss -tlnp | tail -n +2 | wc -l)
udp=$(ss -ulpn | tail -n +2 | wc -l)


# Inicio do script

printf "${AMARELO}Iniciando a análise de rede...${RESET}\n"

echo "$linha"
printf "${CIANO}TCP:${RESET}\n"
ss -tlnp
echo "$linha"

echo "$linha"
printf "${CIANO}UDP:${RESET}\n"
ss -ulpn
echo "$linha"

echo "$linha"
printf "${CIANO}Quantidade${RESET}\n"
printf "${MAGENTA}TCP:${RESET} $tcp\n"
printf "${MAGENTA}UDP:${RESET} $udp\n"
echo "$linha"
