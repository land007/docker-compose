FROM docker:dind

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

#RUN apk --no-cache add bash
RUN apk --no-cache add -U curl bash vim
RUN echo "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" && curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN ls /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && /usr/bin/docker-compose --version

#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/docker-compose --push .
