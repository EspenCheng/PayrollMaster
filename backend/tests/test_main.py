from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json()["message"] == "PayrollMaster API"
    assert response.json()["status"] == "running"


def test_health_check():
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_api_info():
    response = client.get("/api/v1/")
    assert response.status_code == 200
    assert "PayrollMaster API v1" in response.json()["message"]
