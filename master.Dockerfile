FROM alpine:3.12

LABEL maintainer="raditya.saskara@gdn-commerce.com"

ARG JMETER_VERSION="5.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}

RUN apk update \
  && apk upgrade \
  && apk add ca-certificates \
  && update-ca-certificates \
  && apk add --update openjdk8-jre tzdata curl unzip bash \
  && apk add --no-cache nss \
  && rm -rf /var/cache/apk/* \
  && mkdir -p /tmp/dependencies \
  && curl -L --silent https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz \
  && mkdir -p /opt \
  && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt \
  && rm -rf /tmp/dependencies

RUN sed -i 's/#server.rmi.ssl.disable=false/server.rmi.ssl.disable=true/' ${JMETER_HOME}/bin/user.properties

ENV PATH ${JMETER_HOME}/bin:$PATH
COPY jmeter-entrypoint.sh /

EXPOSE 60000

CMD [ "bash","/jmeter-entrypoint.sh" ]


# HOW TO BUILD
# JMETER_VERSION="5.3"
# docker build -f jmeter.Dockerfile --build-arg JMETER_VERSION=5.3 -t "saskaradit/jmeter:5.3" .
# docker run --network=jmeter_jmeter_net -v jmeter_volume:/opt/apache-jmeter-5.3/coba saskaradit/jmeter:5.4 -n -t /opt/apache-jmeter-5.3/coba/test.jmx -l /opt/apache-jmeter-5.3/coba/dash.csv -R 172.22.0.3
# get ip address to a filename ingress.yaml "$(hostname -i).yaml"