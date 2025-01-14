FROM ubuntu:focal-20230801

ENV DOCKER_CHANNEL=stable \
  DOCKER_VERSION=24.0.5 \
  DOCKER_COMPOSE_VERSION=2.22.0 \
  DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install bash wget curl unzip iptables ca-certificates make net-tools iproute2 pigz openjdk-21-jdk \
  && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx \
  && mv /docker/* /bin/ \
  && chmod +x /bin/docker* \
  && curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-$(uname -m)" -o /bin/docker-compose \
  && chmod +x /bin/docker-compose \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION=8.11.1
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
  && unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip \
  && ln -s /opt/gradle/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle

RUN gradle --version

WORKDIR /shared

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
