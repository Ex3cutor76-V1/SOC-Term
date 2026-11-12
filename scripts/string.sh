#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
VERDE=$'\033[32m'
RESET=$'\033[0m'

# Variáveis
cmd="$1"
file="$2"
DATA_DIR="/opt/SOC-Term/data"

# Função de Validação e filtragem de IPs

validar_ip(){

    ip="$1"

    # Divide o IP em partes
    IFS='.' read -r a b c d <<< "$ip"

    # Verifica se possui 4 partes
    if [[ -z "$a" || -z "$b" || -z "$c" || -z "$d" ]]; then
        return 1
    fi

    # Verifica se todas as partes são números
    if ! [[ "$a" =~ ^[0-9]+$ &&
            "$b" =~ ^[0-9]+$ &&
            "$c" =~ ^[0-9]+$ &&
            "$d" =~ ^[0-9]+$ ]]; then
        return 1
    fi

    # Verifica intervalo 0-255
    for octeto in "$a" "$b" "$c" "$d"; do
        if ((octeto < 0 || octeto > 255)); then
            return 1
        fi
    done

    # Remove falsos positivos comuns
    if [[ "$ip" == "0.0.0.0" ]]; then
        return 1
    fi

    if [[ "$a" == "127" ]]; then
        return 1
    fi

    if [[ "$ip" == "255.255.255.255" ]]; then
        return 1
    fi

    return 0
}

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
if ! output=$(strings "$file"); then
    printf "${VERMELHO}Falha ao executar strings.${RESET}\n"
    exit 1
fi

# Variáveis importantes
url=$(echo "$output" | grep -Eo "https?://[^[:space:]\"']+" | sort -u )
ip=$(echo "$output" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | while read -r endereco
do
    if validar_ip "$endereco"; then
        echo "$endereco"
    fi
done | sort -u)

ip_count=$(printf "%s" "$ip" | grep -c .)

mail=$(echo "$output" | grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' | sort -u)

# Identificação de string através de URL e adiciona em um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}URL${RESET}\n"
if [ -n "$url" ]; then
echo "$url"
echo "$url" > "$DATA_DIR/url.txt"
chmod 600 "$DATA_DIR/url.txt"
printf "${CIANO}string salva em salvo em data, use: sct -db${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio.${RESET}\n"
fi

# Identificação de string  através de IP e adiciona um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}IP${RESET}\n"
if [ -n "$ip" ]; then
echo "$ip"
printf "${MAGENTA}Total de IP's Válidos:${RESET} %s\n" "$ip_count"
echo "$ip" > "$DATA_DIR/ip.txt"
chmod 600 "$DATA_DIR/ip.txt"
printf "${CIANO}string salvo em data, use: sct -db${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio${RESET}\n"
fi

# Identificação de string através de Email e adiciona um arquivo de registro caso haja conteúdo relacionado.
printf "${MAGENTA}Email${RESET}\n"
if [ -n "$mail" ]; then
echo "$mail"
echo "$mail" > "$DATA_DIR/mail.txt"
chmod 600 "$DATA_DIR/mail.txt"
printf "${CIANO}string salvo em data, use: sct -db${RESET}\n"
else
printf "${VERMELHO}Conteúdo vazio.${RESET}\n"
fi
;;

# Identificação inválida.
*)
printf "${VERMELHO}Argumento inválido.${RESET}\n"
echo "Use: sudo sct -st <arquivo>"
;;

esac
