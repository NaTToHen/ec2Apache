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
