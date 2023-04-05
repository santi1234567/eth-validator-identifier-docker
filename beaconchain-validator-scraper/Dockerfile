FROM python:alpine3.14

WORKDIR /app

RUN apk update && apk add git

RUN apk add postgresql-dev python3-dev

RUN python -m pip install --upgrade pip

RUN apk add --update gcc libc-dev linux-headers python3

RUN git clone https://github.com/santi1234567/beaconcha.in-validator-scraper.git

WORKDIR /app/beaconcha.in-validator-scraper

RUN pip3 install -r ./requirements.txt

ENTRYPOINT [ "python", "main.py" ]