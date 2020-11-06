FROM golang:alpine AS goapp
RUN apk add git
WORKDIR /gochain
COPY app.go blockchain.html ./
RUN go get -d -v github.com/lib/pq github.com/julienschmidt/httprouter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
EXPOSE 8000
ENV IP=localhost

FROM alpine
WORKDIR /gochain
COPY --from=goapp /gochain /gochain

CMD ["./app"]
