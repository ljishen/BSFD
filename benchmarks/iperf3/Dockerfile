# VERSION 1.2

FROM phusion/baseimage:0.10.1
MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential

ENV FOLDER_NAME iperf
ENV VERSION 3.5

RUN curl -fsSL https://codeload.github.com/esnet/iperf/tar.gz/"${VERSION}" | tar -xz -C /root

WORKDIR /root/"${FOLDER_NAME}"-"${VERSION}"
RUN ./configure && make -j"$(nproc)"

# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Server port for the server to listen on
EXPOSE 5201

WORKDIR /root
COPY run.sh .
ENTRYPOINT ["/sbin/my_init", "--skip-startup-files", "--quiet", "--", "./run.sh"]
