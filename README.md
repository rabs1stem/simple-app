# simple-app

Простое REST API приложение на Python с Docker, Docker,Compose, Bash-диагностикой и Ansible-развертыванием.

## Требования

- Python 3.12+
- pip
- Docker
- Docker Compose
- Git

## Быстрый старт

### Локальный запуск

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r app/requirements.txt
python app/main.py
```

Приложение будет доступно по адресу:

http://localhost:5000

---

### Docker запуск

```bash
docker build -t simple-app .
docker run -p 5000:5000 simple-app
```

Приложение будет доступно по адресу:

http://localhost:5000

---

### Docker Compose

#### Запуск

```bash
docker compose up --build
```

#### Остановка

```bash
docker compose down
```

---

## API Endpoints

### Главная страница

```bash
curl http://localhost:5000/
```

Ответ:

```json
{"message":"Hello, World!"}
```

### Проверка состояния

```bash
curl http://localhost:5000/health
```

Ответ:

```json
{"status":"ok"}
```

### Список пользователей

```bash
curl http://localhost:5000/api/users
```

Ответ:

```json
{"users":[]}
```

---

## Bash-скрипт диагностики

```bash
bash scripts/server-info.sh
```

Скрипт показывает:

- hostname
- версию ОС
- uptime
- версию ядра
- модель процессора
- использование RAM
- использование диска
- доступность API

---

## Тестирование

```bash
pytest app/tests -v
```

---

## Ansible

Проверка конфигурации:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check
```

Запуск:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

---

## Makefile

```bash
make run     # локальный запуск приложения
make test    # запустить тесты
make up      # поднять контейнеры
make down    # остановить контейнеры
make deploy  # ansible deploy
```

---

## Структура проекта

```text
simple-app/
├── app/
│   ├── main.py
│   ├── requirements.txt
│   └── tests/
├── scripts/
│   └── server-info.sh
├── ansible/
├── Dockerfile
├── docker-compose.yml
├── README.md
```

---

## Troubleshooting

### Порт 5000 занят

```bash
sudo lsof -i :5000
```

### Не работает virtualenv

```bash
sudo apt install python3-venv
```

### Ошибка Docker permission denied

```bash
sudo usermod -aG docker $USER
```

После этого выйти из системы и зайти снова.