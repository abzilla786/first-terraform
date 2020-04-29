#!/bin/bash
echo "export DB_HOST='mongodb://${db_priv_ip}:27017/posts'" >> /home/ubuntu/.bashrc
export DB_HOST='mongodb://${db_priv_ip}:27017/posts'
cd /home/ubuntu/appjs
sudo npm install
nodejs seeds/seed.js
npm start
