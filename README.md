# Instancia ec2 com servidor apache e File System EFS

O projeto consiste basicamente em uma instância ec2 com um file system EFS (Elastic File System) integrado, juntamente com a inicialização de um servidor Apache e elastic ip. O servidor é verificado a partir de um script que é executado de 5 em 5 minutos, o script verifica se o serviço Apache esta online e envia um texto para os respectivos arquivos de log online.txt e offline.txt que estão dentro do diretório do EFS, assim, informando o status do servidor.

## Criação da instancia ec2 e inicialização

O tipo de instancia ec2 utilizado foi o t3.small, com 16gb gp3

**Segurança e rede:**
- Para o acesso da instância ec2 utilização de uma chave de segurança é necessária  
- No grupo de segurança foram abertas as portas: 22/TCP, 111/TCP, 111/UDP, 2049/TCP e UDP, 80/TCP, 443/TCP  
***todas as portas foram testadas**

**EFS (Elastic File System)**

O EFS é um serviço de armazenamento em nuvem gerenciado pela Amazon Web Services que fornece um sistema de arquivos compartilhado e escalável para uso com instâncias do Amazon Elastic Compute Cloud (EC2)

Inicialização e montagem

A criação do EFS foi feita apartir do console AWS. A montagem consistiu nos segintes passos:

- instalação das dependências  
```
sudo yum install -y amazon-efs-utils
```
- montagem do file System  
```
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport id da instancia:/ efs

sudo mkdir -p /mnt/efs
```
- Inicialização automatica ao ligar instância  
Foi adicionada uma entrada no arquivo `/etc/fstab`

**Servidor Apache**
- Instalação e execução
```
sudo yum install httpd

sudo systemctl start httpd
```
## Script e monitoramente
Para efetuar o monitoramento e a validação do status do servidor Apache um script foi criado.

```shell
#!/bin/bash

data=$(date +"%d-%m-%Y %H:%M:%S")

# Verifica
if systemctl is-active httpd >/dev/null 2>&1; then
  mensagem="o serviço Apache está online."
  arquivo="online.txt"
else
  mensagem="o serviço Apache está offline."
  arquivo="offline.txt"
fi

echo "No momento $data, $mensagem" >> /mnt/efs/ec2Apache/Henrique/$arquivo
```
O script verifica se o serviço apache/http esta online e dependendo da saída envia o texto para os arquivos **online.txt** e **offline.txt** que estão dentro do diretório do EFS

Menssagem quando validado:
```
No momento 31-03-2023 17:00:02, o serviço Apache está online.  
No momento 31-03-2023 17:05:02, o serviço Apache está online.  
No momento 31-03-2023 17:10:01, o serviço Apache está online.  
No momento 31-03-2023 17:15:01, o serviço Apache está online.  
```
Para executar o script de 5 em 5 minutos ocorreu o uso do crontab. Utilizando o crontab -e e adicionando a linha ao final do arquivo.  
`*/5 * * * * root validacao.sh`
