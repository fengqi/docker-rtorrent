FROM ubuntu:14.04

ADD src /opt
RUN sh /opt/scripts/install.sh

EXPOSE 8090 60103
VOLUME ["/app/sessions", "/app/downloads", "/app/conf", "/app/watch", "/app/share"]

CMD sh /opt/scripts/boot.sh
