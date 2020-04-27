#!/bin/bash

echo "${my_name}"
cd /home/ubuntu/appjs
sudo npm install
pm2 start app.js
