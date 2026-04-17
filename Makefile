run:
	python3 app/main.py

test:
	pytest app/tests -v

up:
	docker-compose up --build -d

down:
	docker-compose down

deploy:
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

help:
	@echo "make run"
	@echo "make test"
	@echo "make up"
	@echo "make down"
	@echo "make deploy"