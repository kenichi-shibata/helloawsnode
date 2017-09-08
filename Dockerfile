FROM ubuntu:16.04
ADD infra/vm/provision.sh /usr/local/bin/provision.sh
RUN ["/usr/local/bin/provision.sh"]
VOLUME app/ /app
ENTRYPOINT ["/app/entrypoint.sh"]
