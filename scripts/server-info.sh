#!/bin/bash
LOG_FILE="app/tests/server-info.log"
echo "==================================================" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script started" >> "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== Server Diagnostics ==="
echo "Дата: $(date)"
echo "Имя машины: $(hostname)"
echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
echo "Ядро системы: $(uname -r)"
echo "Время работы: $(uptime -p)"
echo 
echo "=== Resources ==="
echo "Процессор: $(lscpu | grep "Имя модели" | tr -d "Имя модели:")"
echo "LA: $(uptime | awk -F'load average:' '{print $2}')"
echo
echo "ОЗУ:"
free -h
echo
echo "Диск:"
df -h /
echo
echo "Контейнеры:"
if command -v docker >/dev/null 2>&1; then
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
else
    echo "Docker не установлен"
fi
echo
echo "=== URL Check ==="
BASE_URL="http://localhost:5000"
EXIT_CODE=0
check_url() {
    endpoint=$1
    expected=$2
    code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$endpoint")

    if [ "$code" = "$expected" ]; then
        echo "$endpoint -> OK ($code)"
    else
        echo "$endpoint -> FAIL ($code)"
        EXIT_CODE=1
    fi
}
check_url "/" 200
check_url "/health" 200
check_url "/api/users" 200
check_url "/api/users/999" 404
exit $EXIT_CODE
