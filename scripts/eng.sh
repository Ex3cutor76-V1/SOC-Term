#!/usr/bin/env bash

# Cores
VERDE=$'\033[32m'
AMARELO=$'\033[33m'
VERMELHO=$'\033[31m'
RESET=$'\033[0m'

# Argumento
malware=$1

# Validação
if [[ -z "$malware" || ! -f "$malware" ]]; then
    printf "${VERMELHO}Arquivo inválido.${RESET}\n"
    exit 1
fi

# Nome do arquivo
nome=$(basename -- "$malware")
saida="${nome}-$(date +%F-%H%M%S).asm"
atual=$(pwd)

# Coleta e visualização
printf "${AMARELO}Coletando Assembly do binário...${RESET}\n"

if ! objdump -d -- "$malware" | less; then
printf "${VERMELHO}Falha durante a visualização.${RESET}\n"
exit 1
fi

# Salvando arquivo
read -r -p "Gostaria de salvar o arquivo? (s/n): " resp
resp=${resp,,}

if [[ "$resp" == "s" ]]; then

printf "${AMARELO}Salvando no diretório atual: %s${RESET}\n" "$atual"

if objdump -d -- "$malware" > "$saida"; then
printf "${VERDE}Assembly salvo com sucesso!${RESET}\n"
printf "Arquivo: %s/%s\n" "$atual" "$saida"
else
printf "${VERMELHO}Falha ao salvar o arquivo.${RESET}\n"
exit 1
fi

else
echo "O arquivo não foi salvo."
fi
