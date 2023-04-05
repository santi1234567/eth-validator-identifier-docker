FROM golang:1.20-alpine AS build

WORKDIR /app

RUN apk add --update git

RUN git clone https://github.com/santi1234567/eth-pools-identifier.git .
RUN apk add --update gcc g++

RUN go mod download
RUN go build -o /eth-pools-identifier

ENTRYPOINT ["/eth-pools-identifier"]