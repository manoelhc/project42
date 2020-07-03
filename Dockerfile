FROM python:3.7.4-alpine3.10

WORKDIR /app
COPY requirements.txt .
COPY app.py .
COPY test_reminders.py .

RUN pip install -r requirements.txt
RUN rm requirements.txt

EXPOSE 5000
CMD [ "python", "-m", "flask", "run" ]