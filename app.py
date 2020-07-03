import os
import sys
import datetime


from flask import Flask, Response, request
from flask.json import jsonify


from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base


app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv(
    'DB_CONNECTION') or "sqlite://"

engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'], echo=True)
Session = sessionmaker(bind=engine)

Base = declarative_base()


class Reminder(Base):
    __tablename__ = 'reminder'
    id = Column(Integer, primary_key=True)
    time = Column(String, nullable=False)
    message = Column(String, nullable=False)

    def __init__(self, time, message):
        if time and message:
            self.time = time
            self.message = message
        else:
            raise ValueError
        try:
            datetime.datetime.strptime(time, "%H:%M")
        except BaseException:
            raise ValueError


try:
    Base.metadata.create_all(engine)
except BaseException:
    app.logger.warning('Database Error')
    sys.exit(1)


@app.route('/api/reminders', methods=['POST'])
def add_reminders():
    session = Session()
    try:
        data = request.get_json()
        entry = Reminder(data["time"], data["message"])
        session.add(entry)
        return Response('{"status":"ok"}',
                        status=201,
                        mimetype='application/json')
    except BaseException:
        return Response('{"status":"error"}',
                        status=403,
                        mimetype='application/json')
        session.rollback()
    finally:
        session.commit()


@app.route('/api/reminders', methods=['GET'])
def list_reminders():
    session = Session()
    reminders = session.query(Reminder)
    return jsonify([{"time": data.time, "message": data.message}
                    for data in reminders])


@app.route('/', methods=['GET'])
def ping():
    return "Yes, I'm alive."
