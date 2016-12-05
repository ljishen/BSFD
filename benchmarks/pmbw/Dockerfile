# VERSION 1.0

FROM ubuntu:latest

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        unzip \
        wget

ENV VERSION 4a3b377
ENV FOLDER_NAME pmbw

WORKDIR /root
RUN wget https://github.com/ljishen/BSFD/blob/master/benchmarks/pmbw/${VERSION}.zip \
    && unzip ${VERSION}.zip \
    && rm ${VERSION}.zip \
    && mv pmbw-master $FOLDER_NAME

WORKDIR /root/$FOLDER_NAME
RUN chmod +x configure && ./configure && make

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root
COPY run.sh .
ENTRYPOINT ["./run.sh"]
