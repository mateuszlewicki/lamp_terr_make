FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile
ADD ./bootstrap.sql ./bootstrap.sql
RUN make publish

CMD ["mysqld_safe"]