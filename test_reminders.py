import app
import pytest
import json


@pytest.fixture
def client():
    with app.app.test_client() as client:
        yield client


# Test if it's adding to the db
def test_add_ok_reminder(client):
    rv = client.post('/api/reminders',
                     content_type='application/json',
                     data='{"time": "00:01", "message": "temp"}')

    data = json.loads(rv.data)
    assert 'ok' in data['status']


# Test if you're adding a reminder with wrong time value
def test_add_wrong_time_reminder(client):
    rv = client.post('/api/reminders',
                     content_type='application/json',
                     data='{"time": "24:01", "message": "temp"}')

    data = json.loads(rv.data)
    assert 'error' in data['status']


# Test if you're adding a reminder with empty time value
def test_add_empty_time_reminder(client):
    rv = client.post('/api/reminders',
                     content_type='application/json',
                     data='{"time": "", "message": "temp"}')

    data = json.loads(rv.data)
    assert 'error' in data['status']


# Test if you're adding a reminder with empty message value
def test_add_empty_message_reminder(client):

    rv = client.post('/api/reminders',
                     content_type='application/json',
                     data='{"time": "00:01", "message": ""}')

    data = json.loads(rv.data)
    assert 'error' in data['status']


# Test if it's listing the only one valid entry
def test_list_reminders(client):

    rv = client.get('/api/reminders')
    data = json.loads(rv.data)

    assert len(data) == 1
