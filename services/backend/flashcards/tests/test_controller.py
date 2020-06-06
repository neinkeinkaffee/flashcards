import flask
import os

from flashcards import create_app, db
from flashcards.api import controller

def test_get_all_flashcards(mocker):
    app = create_app()
    app.testing = True
    jsonify_mock = mocker.patch.object(flask, 'jsonify')
    Flashcard_mock = mocker.patch.object(controller, 'Flashcard')
    Flashcard_mock.return_value.query.return_value.all.return_value = []
    with app.test_request_context(
            '/flashcards', method='GET'):
        controller.all_flashcards()
    expected_response = {
        'status': 'success',
        'container_id': os.uname()[1],
        'flashcards': []
    }
    assert jsonify_mock.called_with(expected_response)

def test_post_new_flashcard(mocker):
    app = create_app()
    app.testing = True
    jsonify_mock = mocker.patch.object(flask, 'jsonify')
    session_mock = mocker.patch.object(db, 'session')
    flashcard_json = {
        'chinese': 'Some Chinese', 'english': 'Some English'
    }
    with app.test_request_context(
            '/flashcards', method='POST',
            json=flashcard_json):
        controller.all_flashcards()
    expected_response = {
        'status': 'success',
        'container_id': os.uname()[1],
        'message': 'Flashcard added!'
    }
    assert jsonify_mock.called_with(expected_response)