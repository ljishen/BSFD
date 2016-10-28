# VERSION 1.1

FROM python:2-alpine

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

WORKDIR /root
ADD pybench-r89074.tar.gz .
COPY bench compare run.sh /root/

ENTRYPOINT ["./run.sh"]
