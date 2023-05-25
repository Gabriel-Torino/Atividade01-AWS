
DATE=$(date +%F-%T)
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)

  if [ $STATUS == "active" ]; then
       MESSAGE="O $SERVICE esta ATIVO/Online"
       echo "$DATE $MESSAGE" >> /mnt/efs/Gabriel/online.txt
  else
       MESSAGE="O $SERVICE esta OFFLINE"
       echo "$DATE $MESSAGE" >> /mnt/efs/Gabriel/offline.txt
  fi
