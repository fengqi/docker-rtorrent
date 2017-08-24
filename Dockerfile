FROM ubuntu:14.04

ADD src /opt/src/
RUN chmod +x /opt/src/scripts/* && \
	/opt/src/scripts/install.sh

EXPOSE 8090
EXPOSE 60103

VOLUME /app/sessions/
VOLUME /app/downloads/
VOLUME /app/conf/
VOLUME /app/watch/

CMD sh /opt/src/scripts/boot.sh
