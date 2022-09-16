FROM alpine:edge

ARG USER=nicotine
ARG GROUP=nicotine
ARG PUID=1000
ARG PGID=1000

RUN addgroup -g ${PGID} -S ${GROUP} && \
    adduser -S -D -u ${PUID} -h /nicotine -G ${GROUP} -g nicotine ${USER} && \
    apk update && apk upgrade && \
    apk add --virtual build-dependencies py3-pip py3-setuptools && \
    apk add bash supervisor font-noto-all adwaita-icon-theme dbus && \
    apk add nicotine-plus --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    pip install --upgrade setuptools && \
    pip install mutagen && \
    mkdir -p /nicotine/downloads && \
    chown -R ${USER}:${GROUP} /nicotine && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

EXPOSE 8085

ADD etc /etc

USER ${USER}

ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]