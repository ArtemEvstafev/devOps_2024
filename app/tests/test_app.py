import requests

def test_web_app_responds():
    """Проверяем, что приложение отвечает на запросы"""
    response = requests.get("http://web:5000")
    assert response.status_code == 200

def test_web_app_content():
    """Проверяем, что приложение возвращает правильный контент"""
    response = requests.get("http://web:5000")
    assert "Hello world from" in response.text

