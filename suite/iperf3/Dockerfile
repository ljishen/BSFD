# VERSION 1.0

FROM ubuntu:latest

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        wget

ENV FOLDER_NAME iperf
ENV VERSION 3.1.3

WORKDIR /root
RUN wget https://github.com/esnet/iperf/archive/${VERSION}.tar.gz \
    && tar -xf ${VERSION}.tar.gz \
    && rm ${VERSION}.tar.gz

WORKDIR ${FOLDER_NAME}-${VERSION}
RUN ./configure; make

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root
COPY run.sh .
ENTRYPOINT ["./run.sh"]
