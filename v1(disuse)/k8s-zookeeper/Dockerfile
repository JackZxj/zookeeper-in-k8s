FROM zookeeper:3.5.6

COPY ./scripts/start-zookeeper /apache-zookeeper-3.5.6-bin/bin/
COPY ./scripts/zookeeper-ready /apache-zookeeper-3.5.6-bin/bin/
COPY ./scripts/zookeeper-metrics /apache-zookeeper-3.5.6-bin/bin/

RUN chmod +x /apache-zookeeper-3.5.6-bin/bin/*

RUN ln -s apache-zookeeper-3.5.6-bin/bin/* /usr/bin
