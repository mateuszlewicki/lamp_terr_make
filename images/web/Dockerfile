FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile
ADD ./index.php ./index.php
RUN make publish
CMD /usr/sbin/httpd -k start -D FOREGROUND
