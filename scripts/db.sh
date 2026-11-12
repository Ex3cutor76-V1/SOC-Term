#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
VERDE=$'\033[32m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Função adicional

DELAY=0

# Funções importantes
ip_consulta() {
if [[ -f /opt/SOC-Term/data/ip.txt ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${AMARELO}Lendo arquivo...${RESET}\n"
sleep "$DELAY"
printf "${MAGENTA}======IP======${RESET}\n"
less /opt/SOC-Term/data/ip.txt
else
printf "${VERMELHO}O arquivo não existe...${RESET}\n"
fi
}

mail_consulta() {
if [[ -f /opt/SOC-Term/data/mail.txt ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${AMARELO}Lendo arquivo...${RESET}\n"
sleep "$DELAY"
printf "${MAGENTA}======Email======${RESET}\n"
less /opt/SOC-Term/data/mail.txt
else
printf "${VERMELHO}O arquivo não existe${RESET}\n"
fi
}

url_consulta() {
if [[ -f /opt/SOC-Term/data/url.txt ]]; then
printf "${VERDE}O Arquivo existe!${RESET}\n"
printf "${AMARELO}Lendo arquivo...${RESET}\n"
sleep "$DELAY"
printf "${MAGENTA}======URL======${RESET}\n"
less /opt/SOC-Term/data/url.txt
else
printf "${VERMELHO}O arquivo não existe${RESET}\n"
fi
}

# Começo da consulta
while true; do
ls -lh /opt/SOC-Term/data/

printf "${MAGENTA}Use: ip, mail, url, clear ou q${RESET}\n"
read -p "${CIANO}Qual arquivo gostaria de ler?:${RESET} " arq 
arq=${arq,,}
printf "${AMARELO}Iniciando consulta...${RESET}\n"
sleep 1

case "$arq" in

# Consulta de IP
ip)
ip_consulta
;;
# Consulta de Email
mail)
mail_consulta
;;
# Consulta de URL
url)
url_consulta
;;
clear)
read -p "Apagar dados coletados? (s/n): " resp
resp=${resp,,}

if [[ "$resp" == "s" || "$resp" == "sim" ]]; then
    sudo rm -f /opt/SOC-Term/data/*.txt
    printf "${VERDE}Limpeza completa!${RESET}\n"
else
    printf "${CIANO}Operação cancelada.${RESET}\n"
fi
;;
q)
printf "${AMARELO}Terminando a consulta...${RESET}\n"
sleep "$DELAY"
break
;;
*)
printf "${VERMELHO}Opção inválida${RESET}\n"
;;

esac
done
