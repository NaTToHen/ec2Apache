# Instancia ec2 com servidor apache e File System EFS

O projeto consiste basicamente em uma instância ec2 com um file system EFS (Elastic File System) integrado, juntamente com a inicialização de um servidor Apache. O servidor é verificado a partir de um script que é executado de 5 em 5 minutos, o script verifica se o serviço Apache esta online e envia um texto para os respectivos arquivos de log online.txt e offline.txt que estão dentro do diretório do EFS, assim, informando o status do servidor.

## Criação da instancia ec2 e inicialização

O tipo de instancia ec2 utilizado foi o t3.small, com 16gb gp3

**Segurança e rede:**
- Para o acesso da instância ec2 utilização de uma chave de segurança é necessária  
- No grupo de segurança foram abertas as portas: 22/TCP, 111/TCP, 111/UDP, 2049/TCP e UDP, 80/TCP, 443/TCP

**EFS (Elastic File System)**

O EFS é um serviço de armazenamento em nuvem gerenciado pela Amazon Web Services que fornece um sistema de arquivos compartilhado e escalável para uso com instâncias do Amazon Elastic Compute Cloud (EC2)

Inicialização e montagem

A criação do EFS foi feita apartir do console AWS. A montagem consistiu nos segintes passos:

instalação das dependências
