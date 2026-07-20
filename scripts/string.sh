#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis
cmd="$1"
file="$2"

# Teste para ver se o arquivo existe, caso não exista ele para o comando, caso exista o comando continua.

printf "${AMARELO}Testando arquivo...${RESET}\n"
if [ ! -f "$file" ]; then
printf "${VERMELHO}O arquivo não existe.${RESET}\n"
exit 1
fi
printf "${VERDE}O arquivo existe.${RESET}\n"

# Identificação se é URL, IP ou Email

case "$cmd" in
strings)
output=$(strings "$file")

# Variáveis importantes
url=$(echo "$output" | grep -Eo 'https?://[^ ]+')
ip=$(echo "$output" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
mail=$(echo "$output" | grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')

# Identificação de string através de URL e adiciona em um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}URL${RESET}\n"
if [ -n "$url" ]; then
echo "$url"
echo "$url" > string-url.txt
printf "${CIANO}string salva em string-url.txt${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio.${RESET}\n"
fi

# Identificação de string  através de IP e adiciona um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}IP${RESET}\n"
if [ -n "$ip" ]; then
echo "$ip"
echo "$ip" > string-ip.txt
printf "${CIANO}string salva em string-ip.txt${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio${RESET}\n"
fi

# Identificação de string através de Email e adiciona um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}Email${RESET}\n"
if [ -n "$mail" ]; then
echo "$mail"
echo "$mail" > string-mail.txt
printf "${CIANO}string salva em  string-mail.txt${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio.${RESET}\n"
fi
;;

# Identificação inválida.
*)
printf "${VERMELHO}Argumento inválido.${RESET}\n"
echo "Use: sct -st <arquivo>"
;;

esac
