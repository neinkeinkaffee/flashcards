# -*- coding: utf-8 -*-

from flask.cli import FlaskGroup

from flashcards import create_app, db
from flashcards.api.model import Flashcard


app = create_app()
cli = FlaskGroup(create_app=create_app)


@cli.command('recreate_db')
def recreate_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command('seed_db')
def seed_db():
    """Seeds the database."""
    flashcards = [
        {
            'chinese': '吃了嗎？',
            'english': 'Have you eaten?'
        },
        {
            'chinese': '去哪裡啊？',
            'english': 'Where\'re ya headed?'
        },
        {
            'chinese': '你來對了地方。',
            'english': 'You\'ve come to the right place.'
        },
        {
            'chinese': '屁啦！',
            'english': 'Nonsense!'
        }
    ]
    for flashcard in flashcards:
        db.session.add(Flashcard(
            chinese=flashcard['chinese'],
            english=flashcard['english']
    ))
    db.session.commit()


if __name__ == '__main__':
    cli()
