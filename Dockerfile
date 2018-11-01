FROM ubuntu:18.10

RUN apt update
RUN apt install -y wget libssl-dev bash openssl

RUN mkdir -p /app/ssl/root /app/ssl/out

WORKDIR /app

ENV DOCKER_GEN_VERSION 0.7.4

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

ADD . /app

ENV DOCKER_HOST unix:///var/run/docker.sock

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD docker-gen -interval 10 -watch -notify  "bash /app/generator.sh" /app/generator.tmpl /app/generator.sh