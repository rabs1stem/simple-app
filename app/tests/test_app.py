import sys
import os

sys.path.append(os.path.abspath("app"))

from main import app

client = app.test_client()


def test_index_status():
    response = client.get("/")
    assert response.status_code == 200


def test_index_json():
    response = client.get("/")
    assert response.get_json() == {"message": "Hello, World!"}


def test_health_status():
    response = client.get("/health")
    assert response.status_code == 200


def test_health_json():
    response = client.get("/health")
    assert response.get_json() == {"status": "ok"}


def test_users():
    response = client.get("/api/users")
    assert response.status_code == 200
    assert response.get_json() == {"users": []}