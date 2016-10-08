# VERSION 1.1

FROM ubuntu:latest

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        wget

ENV FOLDER_NAME fhourstones
RUN mkdir /root/$FOLDER_NAME

WORKDIR /root
RUN wget https://tromp.github.io/c4/Fhourstones.tar.gz \
    && tar -xf Fhourstones.tar.gz -C $FOLDER_NAME \
    && rm Fhourstones.tar.gz

RUN gcc -O $FOLDER_NAME/SearchGame.c -o $FOLDER_NAME/SearchGame

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run.sh .
ENTRYPOINT ["./run.sh"]
