FROM ubuntu:20.04
ARG TARGETARCH

ARG S3BucketName
ARG GitUrl
ARG ProjectName
ARG SSH_PRIVATE_KEY
ARG SSH_KNOWN_HOSTS
ARG Distributionid

RUN mkdir /var/task
RUN mkdir /var/task/certs/
RUN echo "${SSH_PRIVATE_KEY}" > /var/task/certs/github
RUN chmod 644 /var/task/certs/github
RUN echo "${SSH_KNOWN_HOSTS}" > /var/task/certs/known_hosts

ENV S3BucketName=$S3BucketName
ENV GitUrl=$GitUrl
ENV ProjectName=$ProjectName
ENV Distributionid=$Distributionid

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        cmake \
        autoconf \
        libtool \
        python3 \
        pip \
        unzip \
        git wget tar gzip

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

ENV FUNCTION_DIR=/var/task

ADD https://github.com/gohugoio/hugo/releases/download/v0.89.3/hugo_0.89.3_Linux-64bit.tar.gz /tmp
RUN tar -xzf /tmp/hugo_0.89.3_Linux-64bit.tar.gz -C /tmp
RUN mv /tmp/hugo /usr/bin && rm -rf /tmp/*
RUN pip3 install awslambdaric

ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "main.handler" ]

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

COPY script.sh $FUNCTION_DIR/script.sh
RUN chmod 755 $FUNCTION_DIR/script.sh

COPY main.py $FUNCTION_DIR/main.py
WORKDIR $FUNCTION_DIR