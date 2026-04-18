#!/bin/bash
LOG_FILE="$HOME/simple-app/scripts/$(date '+%Y-%m-%d_%H-%M-%S').log"
echo "==================================================" >> "$LOG_FILE"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Script started" >> "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== Server Diagnostics ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2)"
echo "Karnel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo 
echo "=== Resources ==="
CPU_CORES=$(nproc)
LA=$(uptime | awk -F 'load average:' '{print $2}')
echo "CPU: ${CPU_CORES} cores, load average:$LA"
USE=$(free -h | awk '/Память/ {print $3}')
TOTAL=$(free -h | awk '/Память/ {print $2}')
FREE=$(free -h | awk '/Память/ {printf"%.0f", $3/$2*100}')
echo "RAM: $USE / $TOTAL (${FREE}%)" 
D_USE=$(df -h /| awk 'NR==2 {print $3}')
D_TOTAL=$(df -h / | awk 'NR==2  {print $2}')
D_FREE=$(df -h / | awk 'NR==2  {printf"%.0f", $3/$2*100}')
echo "Disk: $D_USE / $D_TOTAL (${D_FREE}%)" 
echo
echo "=== Docker ==="
if command -v docker >/dev/null 2>&1; then
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
else
    echo "Docker не установлен"
fi
echo
echo "=== Service Health Checks ==="
BASE_URL="http://localhost:5000"
EXIT_CODE=0
TTOTAL=0
OK_COUNT=0

check_url() {
    endpoint=$1
    expected=$2

    TTOTAL=$((TTOTAL + 1))

    code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$endpoint")

    if [ "$code" = "$expected" ]; then
        echo "[OK]   $BASE_URL$endpoint ($code)"
        OK_COUNT=$((OK_COUNT + 1))
    else
        echo "[FAIL] $BASE_URL$endpoint ($code)"
        EXIT_CODE=1
    fi
}

check_url "/health" 200
check_url "/api/users" 200

echo
echo "Result: $OK_COUNT/$TTOTAL services healthy"
exit $EXIT_CODE
