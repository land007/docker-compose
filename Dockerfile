FROM debian:latest

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

ENV COMPOSE_VERSION 1.25.0

#RUN apk --no-cache add bash
RUN apt-get update && apt-get install -y curl && apt-get clean \
	&& echo "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
	&& curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& ls /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && /usr/bin/docker-compose --version

WORKDIR /app
ENTRYPOINT ["/usr/bin/docker-compose"]
CMD ["--version"]


#docker build -t "land007/docker-compose:latest" .
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/docker-compose --push .
#docker rm -f docker-compose ; docker run -d --privileged --name docker-compose land007/docker-compose:latest
#docker exec -it docker-compose bash
