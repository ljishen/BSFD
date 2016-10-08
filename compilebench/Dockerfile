# VERSION 1.1

FROM python:2-slim

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update \
    && apt-get install -y \
        bzip2 \
        wget

ENV FOLDER_NAME compilebench

WORKDIR /root
RUN wget https://oss.oracle.com/~mason/compilebench/$FOLDER_NAME-0.6.tar.bz2 \
    && tar -xf $FOLDER_NAME-0.6.tar.bz2 \
    && mv $FOLDER_NAME-0.6 $FOLDER_NAME \
    && rm $FOLDER_NAME-0.6.tar.bz2

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run.sh .
ENTRYPOINT ["./run.sh"]
