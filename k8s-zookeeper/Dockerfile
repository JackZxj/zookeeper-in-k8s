FROM zookeeper:3.5.6

ADD ./scripts/* /apache-zookeeper-3.5.6-bin/bin/
RUN chmod +x /apache-zookeeper-3.5.6-bin/bin/*

RUN ln -s apache-zookeeper-3.5.6-bin/bin/* /usr/bin
