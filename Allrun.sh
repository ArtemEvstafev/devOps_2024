#!/bin/bash

docker-compose up --build -d
docker ps

if ! command -v sshpass &> /dev/null; then
  echo "Installing sshpass..."
  sudo apt-get update && sudo apt-get install -y sshpass
fi

PASSWORD="password"

sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub -p 2222 root@localhost
sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub -p 2223 root@localhost
sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub -p 2224 root@localhost

ansible -i hosts java -m ping
ansible-playbook -i hosts main.yml
curl -s -I http://localhost:80

