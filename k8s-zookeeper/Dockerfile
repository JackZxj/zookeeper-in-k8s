FROM zookeeper:3.5.6

MAINTAINER zhangxinjie01@inspur.com

ADD ./*.sh /apache-zookeeper-3.5.6-bin/bin/
RUN chmod +x /apache-zookeeper-3.5.6-bin/bin/*

RUN ln -s apache-zookeeper-3.5.6-bin/bin/* /usr/bin
