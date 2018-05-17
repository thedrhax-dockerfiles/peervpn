FROM alpine:3.7

MAINTAINER Dmitry Karikh <the.dr.hax@gmail.com>

RUN apk add --no-cache --virtual .build-deps \
    curl \
    make \
    gcc \
    musl-dev \
    libressl-dev \
    linux-headers \
    zlib-dev \
 && mkdir -p /tmp/build \
 && cd /tmp/build \
 && curl https://peervpn.net/files/peervpn-0-044.tar.gz > peervpn.tar.gz \
 && tar xfz peervpn.tar.gz --strip-components=1 \
 && make clean all \
 && mv peervpn /usr/local/bin/ \
 && cd / \
 && rm -rf /tmp/build \
 && apk del .build-deps

ADD entrypoint.sh /
EXPOSE 7000/udp
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/peervpn", "/peervpn.conf"]
