FROM centos:8

ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/apache-zookeeper-3.5.6-bin/bin
ENV JAVA_VERSION=8u232
ENV JAVA_BASE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_
ENV JAVA_URL_VERSION=8u232b09

RUN yum install -y wget nmap-ncat.x86_64;
RUN set -eux;    wget -O openjdk.tgz "${JAVA_BASE_URL}x64_linux_${JAVA_URL_VERSION}.tar.gz";    mkdir -p "$JAVA_HOME";    tar --extract   --file openjdk.tgz   --directory "$JAVA_HOME"   --strip-components 1   --no-same-owner  ;    rm -f openjdk.tgz
RUN set -eux;    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64";    chmod +x /usr/local/bin/gosu;    gosu nobody true

ENV ZOOCFGDIR=/conf ZOO_CONF_DIR=/conf ZOO_DATA_DIR=/data ZOO_DATA_LOG_DIR=/datalog ZOO_LOG_DIR=/logs ZOO_TICK_TIME=2000 ZOO_INIT_LIMIT=5 ZOO_SYNC_LIMIT=2 ZOO_AUTOPURGE_PURGEINTERVAL=0 ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 ZOO_MAX_CLIENT_CNXNS=60 ZOO_STANDALONE_ENABLED=true ZOO_ADMINSERVER_ENABLED=true
RUN set -eux;     groupadd -r zookeeper --gid=1000;     useradd -r -g zookeeper --uid=1000 zookeeper;     mkdir -p "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR";     chown zookeeper:zookeeper "$ZOO_DATA_LOG_DIR" "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"

ARG SHORT_DISTRO_NAME=zookeeper-3.5.6
ARG DISTRO_NAME=apache-zookeeper-3.5.6-bin
RUN set -eux;    wget "https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/$SHORT_DISTRO_NAME/$DISTRO_NAME.tar.gz";    tar -zxf "$DISTRO_NAME.tar.gz";     mv "$DISTRO_NAME/conf/"* "$ZOO_CONF_DIR";     rm -rf "$DISTRO_NAME.tar.gz";     chown -R zookeeper:zookeeper "/$DISTRO_NAME"

COPY /docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh && yum clean all && rm -rf /var/cache/yum

WORKDIR /apache-zookeeper-3.5.6-bin
VOLUME [/data /datalog /logs]
EXPOSE 2181 2888 3888 8080

CMD ["/docker-entrypoint.sh" "zkServer.sh" "start-foreground"]