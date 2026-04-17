#!/bin/bash
echo "Имя: $(hostname)"
echo "Версия OC: $(grep PRETTY_NAME /etc/os-release)"
echo "Время работы системы: $(uptime -p)"
echo "Версия ядра: $(uname -r)"
lscpu | grep "Имя модели"
echo "ОЗУ:" 
free -h
echo "Диск:" 
df -h /
echo
curl http://127.0.0.1:5000  
curl http://127.0.0.1:5000/health
curl http://127.0.0.1:5000/api/users