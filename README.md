# O que é o SOC-Term?

O SOC-Term é uma ferramenta CLI voltada para Analistas de SOC, capaz de fazer análises de logs, portas TCP e UDP, monitoramento de processos e serviços rodand e extração de strings, com comandos básicos e vindo do sistema, com o objetivo de facilitar as análises de segurança.

## Dependências:
Na maior parte das instalações não é necessário instalar as dependências, afinal o script install.sh já automaticamente instala essas dependências, mas caso queira saber quais são as dependências, são essas:

```bash 
sudo apt install unzip lsof 
```
O SOC-Term utiliza ferramentas do próprio sistema para as análises, não é preciso de tanta dependência.

## Instalação
Clone o repositório:
```bash 
git clone https://github.com/Ex3cutor76-V1/SOC-Term.git
```
Inicia o script:
```bash
cd SOC-Term
chmod +x install.sh
sudo ./install.sh
```

## Comandos:
| Comando | Descrição |
| --------|-----------|
| `sct -h`| Mostra os comandos |
| `sct -st <arquivo>` | Faz análise de strings de um arquivo |
| `sct -ssh` | Cria um arquivo txt com os logs envolvendo SSH |
| `sct -sys` | Cria um arquivo txt com os logs envolvendo o sistema |
| `sct -svc` | Cria um arquivo txt com os logs envolvendo os serviços |
| `sct -se` | Faz a análise de serviços rodando |
| `sct -pr` | Faz anáise de processos |
| `sct -p` | Faz análise de portas TCP e UDP |
| `sct -l` | Faz a análise de recursos com o lsof |


