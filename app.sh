#!/bin/bash

sleep 120
sudo apt update -y
sudo apt install python3-pip -y
sudo apt install git -y
sudo apt install python3-venv -y
cd /home/ubuntu
git clone https://github.com/ooghenekaro/flask-app.git
cd flask-app
sudo pip3 install -r requirements.txt --break-system-packages
echo "[Unit]
Description=Flask Application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/flask-app
ExecStart=/usr/bin/python3 /home/ubuntu/flask-app/rest.py
Environment='PATH=/usr/bin'
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/flask-app.service
sudo systemctl daemon-reload
sudo systemctl enable flask-app
sudo systemctl start flask-app
