FROM golang:alpine AS builder
RUN apk add git
WORKDIR /gochain
COPY app.go blockchain.html ./
RUN go get -d -v github.com/lib/pq github.com/julienschmidt/httprouter
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .
EXPOSE 8000
ENV IP=localhost

FROM scratch
WORKDIR /gochain
COPY --from=builder /gochain /gochain

CMD ["./app"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD echo ok || exit 1
