FROM land007/debian:latest

MAINTAINER Jia Yiqiu <yiqiujia@hotmail.com>

##--docker-compose--
#ENV COMPOSE_VERSION=1.25.0
#
##RUN apk --no-cache add bash
#RUN apt-get update && apt-get install -y curl iptables net-tools && apt-get clean \
#     && echo "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
#     && curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
#     && ls /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose && /usr/bin/docker-compose --version
#
#RUN apt-get --allow-releaseinfo-change update && apt-get --allow-releaseinfo-change update && #ENTRYPOINT ["/usr/bin/docker-compose"]
##CMD ["--version"]

RUN export TARGETPLATFORM=$(uname -m) && \
    case ${TARGETPLATFORM} in \
         "x86_64")  PLATFORM_ARCH=amd64  ;; \
         "aarch64")  PLATFORM_ARCH=arm64  ;; \
         "armv7l") PLATFORM_ARCH=armhf  ;; \
    esac && \
    apt-get --allow-releaseinfo-change update && \
    apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
#     && apt-get clean \
     && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
     && add-apt-repository \
     "deb [arch=${PLATFORM_ARCH}] https://download.docker.com/linux/debian \
     $(lsb_release -cs) \
     stable" \
     && apt-key fingerprint 0EBFCD88 \
     && apt-get update \
     && apt-get install -y docker-ce docker-compose\
     && apt-get clean
#CMD service docker start ; /usr/bin/docker-compose --version ; bash

VOLUME /var/lib/docker

#ADD portainer-portainer-latest-5-cc61cd4105c3.layer.tar.gz /
RUN export TARGETPLATFORM=$(uname -m) && \
    case ${TARGETPLATFORM} in \
         "x86_64")  PLATFORM_ARCH=amd64  ;; \
         "aarch64")  PLATFORM_ARCH=arm64  ;; \
         "armv7l") PLATFORM_ARCH=arm  ;; \
    esac && \
    curl -L https://github.com/portainer/portainer/releases/download/2.11.1/portainer-2.11.1-linux-${PLATFORM_ARCH}.tar.gz  -o /tmp/portainer.tar && \
    tar -zxvf /tmp/portainer.tar -C / && rm -f portainer.tar && ls /portainer
COPY iptables.sh	/
RUN chmod +x /portainer/portainer && \
	chmod +x /iptables.sh

#--buildx--
#RUN cd /opt && git clone git://github.com/docker/buildx && \
#	cd buildx && make install && \
#	mkdir -p ~/.docker/cli-plugins && \
#	cp buildx ~/.docker/cli-plugins/docker-buildx && \
#	chmod a+x ~/.docker/cli-plugins/docker-buildx && \
#	rm -rf /opt/buildx
ADD config.json /root/.docker/
ADD check.sh /

ENV APP_REPOSITORY=https://github.com/land007/docker-compose-app.git

RUN export TARGETPLATFORM=$(uname -m) && \
    case ${TARGETPLATFORM} in \
         "x86_64")  PLATFORM_ARCH=amd64  ;; \
         "aarch64")  PLATFORM_ARCH=arm64  ;; \
         "armv7l") PLATFORM_ARCH=arm-v7  ;; \
    esac && \
    mkdir -p /root/.docker/cli-plugins/ && \
	curl -L "https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-${PLATFORM_ARCH}" -o /root/.docker/cli-plugins/docker-buildx && \
	chmod +x /root/.docker/cli-plugins/docker-buildx && \
	sed -i 's/\r$//' /check.sh && chmod a+x /check.sh && \
	echo 'service docker start' >> /start.sh && \
#	echo 'rm -rf /app/*' >> /start.sh && \
	echo '/check.sh ${APP_REPOSITORY} /app' >> /start.sh && \
	echo 'cd /app && /usr/bin/docker-compose up -d' >> /start.sh && \
	echo '/iptables.sh' >> /start.sh && \
	echo '/portainer/portainer &' >> /start.sh && \
	mkdir /app && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/docker-compose" >> /.image_names && \
	echo "land007/docker-compose" > /.image_name

VOLUME /app
WORKDIR /app

EXPOSE 9000/tcp 2375/tcp

#CMD /check.sh /app ; /app/start.sh ; bash

#docker build -t "land007/docker-compose:latest" .
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/docker-compose:new --push .
#docker rm -f docker-compose ; docker run -d --privileged --name docker-compose land007/docker-compose:latest
#docker exec -it docker-compose bash
#docker rm -f docker-compose ; docker run -it --rm --privileged --name docker-compose land007/docker-compose:latest bash
#docker rm -f docker-compose ; docker run -it --rm --privileged --name docker-compose -v ~/docker/var-lib-docker:/var/lib/docker land007/docker-compose:latest bash
#docker rm -f docker-compose ; docker run -it --rm --privileged --name docker-compose -v /var/run/docker.sock:/var/run/docker.sock land007/docker-compose:latest bash
#docker rm -f docker-compose ; docker run -it --rm --privileged -p 9009:9000 --name docker-compose -v ~/docker/app:/app land007/docker-compose:latest
#docker rm -f docker-compose ; docker run -it --rm --privileged --name docker-compose -v /var/run/docker.sock:/var/run/docker.sock -v ~/.docker:/root/.docker -v ~/docker/app:/app docx.msa.gov.cn:5000/docker-compose:new bash

#iptables -I OUTPUT -o eth0 -s 172.19.0.0/16 -d 127.0.0.0/16 -j ACCEPT
#iptables -I OUTPUT -o eth0 -s 172.19.0.0/16 -d 127.0.0.0/16 -j ACCEPT
#iptables -I OUTPUT 2 -o eth0 -s 172.19.0.0/16  -j REJECT

#docker run -it --rm --privileged -p 9009:9000 --name docker-compose land007/docker-compose:latest

