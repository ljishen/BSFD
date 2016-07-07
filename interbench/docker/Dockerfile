# VERSION 1.0

FROM ubuntu:latest

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        unzip \ 
        wget

ENV FOLDER_NAME interbench

WORKDIR /root
RUN wget https://github.com/Mustaavalkosta/interbench/archive/master.zip \
    && unzip master.zip \
    && rm master.zip \
    && mv interbench-master $FOLDER_NAME

WORKDIR $FOLDER_NAME
RUN make

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["./interbench", "-c"]
CMD ["-r", "-L", "1"]
