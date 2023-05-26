# Linux AWS + NFS + Httpd | CompassUOL 2023. 
 **Objetivo**: Neste documento, vamos mostrar como criar uma instância EC2 na AWS (Amazon Web Services) com um servidor HTTPD (Apache) disponível e configurar um script de "Status Check" automatizado para gerar o resultado dentro de um arquivo no EFS (Elastic File System), que também será configurado e montado na máquina.
 
 **Escopo**:
- Geração de uma chave pública de acesso.
- Criação de uma instância EC2 utilizando o sistema operacional Amazon Linux.
- Geração de um endereço IP elástico e associá-lo à instância EC2.
- Liberação de portas de comunicação para permitir o acesso público através do "Security Group";   
    - 22/TCP (SSH) para acesso via Secure Shell
    - 111/TCP e UDP (RPC) para Remote Procedure Call
    - 2049/TCP/UDP (NFS) para Network File System
    - 80/TCP (HTTP) para tráfego da Web
    - 443/TCP (HTTPS) para tráfego seguro da Web
- Configuração do NFS/EFS na AWS).
- Criar um diretório com o nome de usuário dentro do filesystem NFS no Linux.
- Instalação e configuração do Httpd no Linux.
- Criação de um script para verificar se o serviço do Apache está online ou não e enviar o resultado com saída para online ou offline para o diretório NFS no Linux.
- Configuração do Script para executar a cada 5 minutos.

## Requisitos AWS:
  É necessário ter a seguinte configuração na AWS:
* Possuir usuário AWS com credenciais válidas para os serviços de EC2. 
* Chave pública para acesso ao ambiente
* AMI: Amazon Linux
    * Type: t3.small
    * Configure Storage: 16 GB SSD(gp2)
* Gerar 1 "Elastic IP" e anexar à instância EC2;
* Portas de comunicação liberadas"
    * 22/TCP (SSH) 
    * 111/TCP e UDP (RPC) 
    * 2049/TCP/UDP (NFS) 
    * 80/TCP (HTTP) 
    * 443/TCP (HTTPS)
    
  ### Requisitos Linux EC2: 
  É necessário ter uma instância Amazon Linux (EC2) com a seguinte configuração: 
* Configurar o NFS funcional.
* Criar um diretório dentro do filesystem do NFS com o nome do usuário;
* Subir um servidor Httpd. O mesmo deve estar online e rodando.
* Criar um script que valide se o status do serviço e envie o resultado para o seu diretorio no NFS.
* O script deve conter; Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou OFFLINE.
* O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE.
* Preparar a execução automatizada do script a cada 5 minutos.
---
## Execução de projeto:
### Gerar uma chave pública de acesso na AWS;
+ Acessar a página da AWS > pesquisar o Serviço (**EC2**) > no menu esquerdo > "**Network e Security**" clicar > "**Key Pairs**", seguido de "**Create Key Pair**" um nome indentificável e manter o type em: "**RSA**" e alterar o "**Private key file format**" para (**.PEM)**. Guardar em um local seguro!.

### Configuração das portas
+ Continuando no serviço (**EC2**) > no menu esquerdo em "**Network e Security"** clicar > "**Security Groups**" > "**Create Security Group**" em "**Inbound rules**" vamos adicionar a seguinte configuração e criar o grupo de segurança:
 Tipo | Protocolo | Portas | Origem | Descrição
    ---|---|---|---|---
    SSH | TCP | 22 | 0.0.0.0/0 | SSH
    TCP personalizado | TCP | 80 | 0.0.0.0/0 | HTTP
    TCP personalizado | TCP | 443 | 0.0.0.0/0 | HTTPS
    TCP personalizado | TCP | 111 | 0.0.0.0/0 | RPC
    UDP personalizado | UDP | 111 | 0.0.0.0/0 | RPC
    TCP personalizado | TCP | 2049 | 0.0.0.0/0 | NFS
    UDP personalizado | UDP | 2049 | 0.0.0.0/0 | NFS


### Criando máquina no EC2:
+ Com o ambiente AWS pronto, criar a instância Linux seguindo as intruções >
+ Continuando no serviço (**EC2**) > no menu esquerdo > "**Instances"** clicar > "**Launch Instances**". Dar um nome a máquina, selecionar AMI; "**Amazon Linux 2023 AMI**". A baixo selecionar a opção do type: **t3.small**, Selecionar a "**Key Pair**" criada anteriormente, assim como o "**Security Group**" já criado também. Em storage selecionar **16GB** e **(GP3)** > Criar máquina.
### Gerar e anexar o ElasticIP à instância:
+ Continuando no serviço (**EC2**) no menu esquerdo > "**Network e Security"** clicar > "**Elastic IP**" > no botão "**Allocate Elastic IP Addres**" Verificar se o Elastic IP está selecionado na mesma região da instância e criar. Selecionar o Elastic IP criado > "**Actions**" > "**Associate Elastic IP Address**" nesse menu, vamos selecionar a "**Instance**" criada e "**Resource Type** e logo a baixo em "**Private IP Address**" selecionar o IP Privado da nossa instância já criada. Após isso **Associate**. 
### Configurar NFS com EFS/AWS:
+ Precisamos criar um security Group com a saída TCP/UDP intervalo de porta 2049 e também acesso SSH na porta 22 para o nosso EFS

|     Type      |   Protocol    |   Port Range   |   Source   | 
| ------------- | ------------- | -------------- | ---------- |
|      SSH      |      SSH     |       22       |  0.0.0.0\0 |
|      NFS      |      TCP     |      2049      |  0.0.0.0\0 |
|      NFS      |      UDP     |      2049      |  0.0.0.0\0 | 

+ Acessar serviço **EFS** > **Create File System** > Selecionar nome e VPC da instância EC2. > Em "**Network**". Selecionar o Security Group criado para o EFS **Attach** Copiar comando de montagem para client e colar no terminal se atentando ao /diretório montado. > Criar diretório com nome **"Gabriel"** dentro do diretório montado > Editar "nano **/etc/fstab**" para montar também no Boot do sistema > com a linha de comando **"IDfs-12345678:/ /mnt/efs nfs4 defaults,_netdev 0 0"**. Verificar se o NFS foi montado usando o comando **df -h** e reiniciar o sistema.
### Configurando serviço HTTPD(apache):
+  Instalar: **dnf install httpd**. Iniciar apache > **systemctl start httpd**. Iniciar no Boot do sistema > **systemctl enable httpd**. Verificar status do serviço > **systemctl status httpd**.
### Configurando Script de verificação do HTTPD(apache):
<details>
<summary>Clique se precisar configurar o fuso horário da máquina EC2.</summary>

## Ao acessar o terminal execute o comando:
timedatectl set-timezone America/Sao_Paulo

## Para confirmar a alteração, execute o seguinte comando
timedatectl

</details>

+ Para criar um script: "editor nome.sh" Ex: *nano script.sh"
+ Inserir as seguintes linhas de código
```bash
DATE=$(date +%F-%T)
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)

  if [ $STATUS == "active" ]; then
       MESSAGE="O serviço $SERVICE esta ATIVO/Online"
       echo "$DATE $MESSAGE" >> /mnt/efs/Gabriel/online.txt
  else
       MESSAGE="O serviço $SERVICE esta OFFLINE"
       echo "$DATE $MESSAGE" >> /mnt/efs/Gabriel/offline.txt
  fi
  ```
  + Salve o script > Altere para arquivo executável **chmod +x script.sh** > Execute **./script.sh**
### Configurando arquivo para execução automática em 5 minutos.
+ Instalação **dnf install cronie**. Configurar > **crontab -e** adicionado o seguinte código;
+ ***/5 * * * * /home/check_httpd.sh** > Salvar e dar restart ao serviço. **systemctl restart crond**.
  
