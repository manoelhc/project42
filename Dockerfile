FROM python:3.7.4-alpine3.10

WORKDIR /app
COPY requirements.txt .
COPY app.py .

RUN apk --no-cache add --virtual build-dependencies \
    build-base \
    py-mysqldb \
    gcc \
    libc-dev \
    libffi-dev \
    mariadb-dev \
    mariadb-connector-c \
    && pip install -qq -r requirements.txt \
    && rm -rf .cache/pip \
    && apk del build-dependencies

EXPOSE 5000
CMD [ "python", "-m", "flask", "run" ]