# -*- coding: utf-8 -*-

from flashcards import create_app, db
from flashcards.api.model import Flashcard

def setup_function():
    app = create_app()
    app.testing = True
    ctx = app.app_context()
    ctx.push()
    db.create_all()

def teardown_function():
    db.drop_all()
    db.create_all()

def test_adding_new_card():
    db.session.add(Flashcard(
        chinese='吃了嗎？',
        english='Have you eaten?'))
    db.session.commit()

    flashcards = Flashcard.query.all()
    assert len(flashcards) == 1
    assert Flashcard.query.all()[0].english == 'Have you eaten?'

def test_adding_two_new_cards():
    db.session.add(Flashcard(
        chinese='夠了嗎？',
        english='Enough?'))
    db.session.add(Flashcard(
        chinese='吃了嗎？',
        english='Have you eaten?'))
    db.session.commit()

    flashcards = Flashcard.query.all()
    assert len(flashcards) == 2
    assert flashcards[0].english == 'Enough?'
    assert flashcards[1].english == 'Have you eaten?'
