#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variável do arquivo
arquivo="$2"

# Teste de existência do arquivo
if [[ ! -f "$arquivo" ]]; then
    printf "${VERMELHO}Arquivo inexistente.${RESET}\n"
    exit 1
fi

# Variáveis importantes

nome=$(basename "$arquivo")
tipo=$(file -b "$arquivo")
tamanho=$(du -sh "$arquivo" | cut -f1)
permissao=$(stat -c %A "$arquivo")
user=$(stat -c %U "$arquivo")
grupo=$(stat -c %G "$arquivo")
data=$(stat -c %y "$arquivo")
extensao=$(echo "${arquivo##*.}")
hash=$(sha256sum "$arquivo" | awk '{print $1}')
linha="======================================================================"

printf "${CIANO}Informações do arquivo${RESET}\n"
echo "$linha"

# Exibe nome, tipo, tamanho, permissões, dono, grupo, data de criação e extensão do arquivo
printf "${MAGENTA}Nome do arquivo:${RESET} %s\n" "$nome"
printf "${MAGENTA}Tipo de arquivo:${RESET} %s\n" "$tipo"
printf "${MAGENTA}Tamanho:${RESET} %s\n" "$tamanho"
printf "${MAGENTA}Permissões:${RESET} %s\n" "$permissao"
printf "${MAGENTA}Dono do arquivo:${RESET} %s\n" "$user"
printf "${MAGENTA}Grupo:${RESET} %s\n" "$grupo"
printf "${MAGENTA}Última modificação:${RESET} %s\n" "$data"
printf "${MAGENTA}Extensão do arquivo:${RESET} %s\n" "$extensao"
printf "${MAGENTA}SHA256:${RESET} %s\n" "$hash"
