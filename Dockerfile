FROM alpine
RUN apk update && \
apk upgrade && \
apk add varnish

ENV VARNISH_PORT 80
ENV VARNISH_BACKEND 80

EXPOSE ${VARNISH_PORT}

COPY default.vcl /etc/varnish
ADD start /
RUN chmod +x /start
CMD ["/bin/sh","/start"]
