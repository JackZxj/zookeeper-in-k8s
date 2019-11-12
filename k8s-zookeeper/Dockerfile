FROM zookeeper:3.5.6

MAINTAINER zhangxinjie01@inspur.com

ADD ./start-zookeeper.sh /apache-zookeeper-3.5.6-bin/bin/
ADD ./zookeeper-metrics.sh /apache-zookeeper-3.5.6-bin/bin/
ADD ./zookeeper-ready.sh /apache-zookeeper-3.5.6-bin/bin/

RUN ln -s apache-zookeeper-3.5.6-bin/bin/* /usr/bin

EXPOSE 2181 2888 3888