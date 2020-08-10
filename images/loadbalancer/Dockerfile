FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile

RUN make dev

CMD haproxy -f /etc/haproxy/haproxy.cfg