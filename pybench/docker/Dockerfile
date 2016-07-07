# VERSION 1.0

FROM python:2-alpine

MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

WORKDIR /root
ADD pybench-r89074.tar.gz .

COPY run /bin
COPY compare /bin

RUN mkdir results
CMD ["pybench/pybench.py", "-h"]
