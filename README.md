# Linux AWS + NFS Client + Httpd | CompassUOL 2023. 
 **Objetivo**: Criar um ambiente EC2 que comporte um servidor **Httpd** e tenha um script "Status Check" automatizado junto ao NFS.
 
 **Escopo**:
- Geração de uma chave pública de acesso.
- Criação de uma instância EC2 utilizando o sistema operacional Amazon Linux.
- Geração de um endereço IP elástico e associá-lo à instância EC2.
- Configurar gateway de internet.
- Configurar rota de internet.
- Liberação de portas de comunicação para permitir o acesso público através do "Security Group";   
    - 22/TCP (SSH) para acesso via Secure Shell
    - 111/TCP e UDP (RPC) para Remote Procedure Call
    - 2049/TCP/UDP (NFS) para Network File System
    - 80/TCP (HTTP) para tráfego da Web
    - 443/TCP (HTTPS) para tráfego seguro da Web
- Configuração do NFS no Linux).
- Criação de um diretório com o nome do usuário no filesystem do NFS no Linux.
- Instalação e configuração do Httpd no Linux.
- Criação de um script para verificar se o serviço do Apache está online e enviar o resultado para o diretório NFS no Linux.
- Configuração do "Status Check" e execução do mesmo a cada 5 minutos no Linux.
 

---
## Requisitos AWS;
* Possuir usuário AWS com credenciais válidas para os serviços de EC2 e VPC. 
* Chave pública para acesso ao ambiente
* AMI: Amazon Linux
    * Type: t3.small
    * Configure Storage: 16 GB SSD(gp2)
* Gerar 1 "Elastic IP" e anexar à instância EC2;
* Portas de comunicação liberadas através do "Security Group"
    * 22/TCP (SSH) 
    * 111/TCP e UDP (RPC) 
    * 2049/TCP/UDP (NFS) 
    * 80/TCP (HTTP) 
    * 443/TCP (HTTPS)
    
  ### Configurações Linux EC2: 
* Configurar o NFS funcional;
* Criar um diretório dentro do filesystem do NFS com o nome do usuário;
* Subir um Httpd - o mesmo deve estar online e rodando;
* Criar um script que valide se o status do serviço e envie o resultado para o seu diretorio no NFS;
* O script deve conter; Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou OFFLINE;
* O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;
* Preparar a execução automatizada do script a cada 5 minutos

## Instruções de configuração:
### Gerar uma chave pública de acesso na AWS;
+ Acessar a página da AWS, pesquisar o Serviço (**EC2**) e no menu esquerdo em "**Network e Security**" clickar em "**Key Pairs**", seguido de "**Create Key Pair**" um nome indentificável e manter o type em: "**RSA**" e alterar o "**Private key file format**" para (**.PEM)**. Guardar em um local seguro!.

### Configuração das portas
+ Continuando no serviço (**EC2**) e no menu esquerdo em "**Network e Security"** clickar em "**Security Groups**" e "**Create Security Group**" em "**Inbound rules**" vamos adicionar a seguinte configuração e criar o grupo de segurança.;
 Tipo | Protocolo | Intervalo de portas | Origem | Descrição
    ---|---|---|---|---
    SSH | TCP | 22 | 0.0.0.0/0 | SSH
    TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP
    TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS
    TCP personalizado | TCP | 111 | 0.0.0.0/0 | RPC
    UDP personalizado | UDP | 111 | 0.0.0.0/0 | RPC
    TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS
    UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS


### Criando máquina no EC2;
+ Continuando no serviço (**EC2**) e no menu esquerdo em "**Instances"** clickar em "**Launch Instances**". Dar um nome a máquina, selecionar AMI; "**Amazon Linux 2023 AMI**". A baixo vamos selecionar a opção do type; **t3.small**, Selecionar a "**Key Pair**" criada anteriormente, assim como o "**Security Group**" já criado também. Em storage selecionar 16GB e (GP3).
### Gerar e anexar o ElasticIP a instância;
+ Continuando no serviço (**EC2**) e no menu esquerdo em "**Network e Security"** clickar em "**Elastic IP**" e no botão "**Allocate Elastic IP Addres**" Verificar se o Elastic IP está selecionado na mesma região da instância e criar. Após isso, selecionar o Elastic IP e em "**Actions**" "**Associate Elastic IP Address**" nesse menu, vamos selecionar "**Instance**" em "**Resource Type** e logo a baixo em "**Private IP Address**" selecionar o IP Privado da nossa instância já criada. Após isso **Associate**. 
### Configurar gateway de internet;
+ Pesquisar e acessar o serviço de **VPC**


  
