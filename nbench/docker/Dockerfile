# VERSION 1.0

FROM ubuntu:latest

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        build-essential

ENV FOLDER_NAME nbench

WORKDIR /root
ADD $FOLDER_NAME-byte-2.2.3.tar.gz .
RUN mv $FOLDER_NAME-byte-2.2.3 $FOLDER_NAME

WORKDIR $FOLDER_NAME
RUN make

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["./nbench"]
