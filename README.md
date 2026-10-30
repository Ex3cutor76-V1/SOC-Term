# O que é o SOC-Term?
O SOC-Term é uma ferramenta CLI voltada para análises de SOC, com o objetivo de facilitar análises de segurança em ambientes Linux.
 Ele reúne verificações comuns realizadas durante as triagens de segurança.

## Funcionalidades

### Análise de Logs
Realiza análise e coleta de informações presentes em logs do sistema:

  * Sistema
  * SSH
  * Serviços
  * Kernel

### Análise de Rede
Auxilia na identificação de informações relacionadas à rede:

  * Identificação de portas TCP
  * Identificação de portas UDP

### Monitoramento
Permite visualizar informações sobre o estado atual do sistema:

  * Processos em execução
  * Serviços ativos

### Arquivos
Permite fazer análises sobre um arquivo, podendo conter:

* Extração de strings (URL, IP ou Email)
* Análise de hash (MD5, SHA256, SHA512)
* Informações sobre o arquivo 

### Usuários
Faz uma análise de uma lista de usuários, podendo ter usuários como:

* Usuários comuns (humanos)
* Usuários de serviços (Sistema)

### Consultas

* Consultas de strings
* Consultas de logs
* Consultas de URL com virustotal

## Dependências
O SOC-Term utiliza principalmente ferramentas já presentes no sistema Linux para realizar suas análises, mantendo poucas dependências externas:

```bash 
sudo apt install unzip lsof iproute2 file curl jq
```
OBS: Esses pacotes normalmente são instalados automaticamente pelo `install.sh`.
As dependências utilizadas no SOC-Term servem para:

`unzip`: Utilizado no processo de instalação.

`lsof`: Utilizado para análises de arquivos, processos e recursos em uso.

`file`: Utilizado para encontrar informações sobre um arquivo.

`iproute2`: Usado em ss nas análises de UDP e TCP.

`curl`: Usado na consulta de URL para usar o virustotal.

`jq`: Usado para organizar as informações que o virustotal entregar.

## Instalação
Clone o repositório:
```bash 
git clone https://github.com/Ex3cutor76-V1/SOC-Term.git
```
Inicia o script:
```bash
cd SOC-Term
sudo ./install.sh
```

## Comandos
| Comando | Descrição |
| --------|-----------|
| `sudo sct -h` ou `sudo sct --help` | Mostra os comandos |
| `sudo sct -st <arquivo>` ou `sudo sct -st <arquivo>` | Faz análise de strings de um arquivo |
| `sudo sct -ssh` ou `sudo sct --ssh` | Cria um arquivo txt com os logs envolvendo SSH |
| `sudo sct -sys` ou `sudo sct --system`| Cria um arquivo txt com os logs envolvendo o sistema |
| `sudo sct -svc` ou `sudo sct --service` | Cria um arquivo txt com os logs envolvendo os serviços |
| `sudo sct -krn` ou `sudo sct --kernel` | Cria um arquivo txt com os logs envolvendo o kernel |
| `sudo sct -se` ou  `sudo sct --analyze-service` | Faz a análise de serviços rodando |
| `sudo sct -pr` ou `sudo sct --process` | Faz análise de processos |
| `sudo sct -p` ou `sudo sct --ports` | Faz análise de portas TCP e UDP |
| `sudo sct -l` ou `sudo sct --lsof` | Faz a análise de recursos com o lsof |
| `sudo sct -db` ou `sudo sct --database` | Consulta strings |
| `sudo sct --log` ou `sudo sct -lo` | Consulta logs |
| `sudo sct -a <arquivo>` ou `sudo sct --analyze-hash` | Análise de hash de um arquivo |
| `sudo sct -i <arquivo>` ou `sudo sct --information` | Informações sobre um arquivo | 
| `sudo sct -u` ou `sudo sct --users` | Análise de usuários do sistema | 
| `sudo sct -v` ou `sudo sct --version` | Versão da ferramenta |
| `sudo sct --upgrade` ou `sudo sct -up` | Atualiza a ferramenta |
| `sudo sct -ur` ou `sudo sct --analyze-url` | Realiza consulta no virustotal |

## Por que a ferramenta usa root?

O SOC-Term na versão 4.1 utiliza root, por conta que alguns comandos do próprio ambiente Linux que necessitam de execução root, como
por exemplo, análises profundas de UDP e TCP necessitam de root para analisar os processos que usam alguma porta, a mesma coisa para
salvar strings e logs do próprio sistema.

## API do virustotal

Para poder realizar consultas no virustotal é necessário de uma API, caso você não tenha uma conta gratuita pelo menos no virustotal, você não irá conseguir utilizar, recomendável criar uma conta gratuita no virustotal primeiro e pegar sua API e registra-la em /opt/SOC-Term/API/API.txt

E aviso direto: A API é armazenada no **seu dispositivo** e é apenas sua, **não compartilhe** com ninguém.
