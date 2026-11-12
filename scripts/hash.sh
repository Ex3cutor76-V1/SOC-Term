#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variável
arquivo="$2"

# Script iniciando as análises de hash

printf "${AMARELO}Analisando hashes${RESET}\n"
sleep "$DELAY"
if [[ ! -f "$arquivo" ]]; then
    printf "${VERMELHO}Arquivo inexistente.${RESET}\n"
    exit 1
fi

# Variáveis importantes
MD5=$(md5sum "$arquivo" | awk '{print $1}')
SHA512=$(sha512sum "$arquivo" | awk '{print $1}')
SHA256=$(sha256sum "$arquivo" | awk '{print $1}')
DELAY=1

printf "${CIANO}Arquivo analisado:${RESET} %s\n" "$arquivo"

printf "${MAGENTA}MD5${RESET}\n"
echo "$MD5"

printf "${MAGENTA}SHA256${RESET}\n"
echo "$SHA256"

printf "${MAGENTA}SHA512${RESET}\n"
echo "$SHA512"

printf "${CIANO}Os hashes podem ser consultados em plataformas de inteligência de ameaças, como VirusTotal, quando apropriado.${RESET}\n"
