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

## Dependências
O SOC-Term utiliza principalmente ferramentas já presentes no sistema Linux para realizar suas análises, mantendo poucas dependências externas:

```bash 
sudo apt install unzip lsof iproute2 file
```
OBS: Esses pacotes normalmente são instalados automaticamente pelo `install.sh`.
As dependências utilizadas no SOC-Term servem para:

`unzip`: Utilizado no processo de instalação.
`lsof`: Utilizado para análises de arquivos, processos e recursos em uso.

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
| `sct -h`| Mostra os comandos |
| `sct -st <arquivo>` | Faz análise de strings de um arquivo |
| `sct -ssh` | Cria um arquivo txt com os logs envolvendo SSH |
| `sct -sys` | Cria um arquivo txt com os logs envolvendo o sistema |
| `sct -svc` | Cria um arquivo txt com os logs envolvendo os serviços |
| `sct -krn` | Cria um arquivo txt com os logs envolvendo o kernel |
| `sct -se` | Faz a análise de serviços rodando |
| `sct -pr` | Faz anáise de processos |
| `sct -p` | Faz análise de portas TCP e UDP |
| `sct -l` | Faz a análise de recursos com o lsof |
| `sct -db` | Consulta strings |
| `sct --log` | Consulta logs |
| `sct -a <arquivo>` | Análise de hash de um arquivo |
| `sct -i <arquivo>` | Informações sobre um arquivo | 
| `sct -u` | Análise de usuários do sistema | 
| `sct -v` | Versão da ferramenta |
