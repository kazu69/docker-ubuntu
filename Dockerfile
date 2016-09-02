FROM ubuntu:14.04
MAINTAINER kazu69

ENV LANG=ja_JP.UTF-8

RUN echo "Asia/Tokyo" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install curl \
                        wget \
                        git \
                        openssl \
                        unzip \
                        vim \
                        build-essential \
                        language-pack-ja \
                        libssl-dev \
                        libreadline-dev \
                        libxml2-dev \
                        libjpeg-dev \
                        libpng12-dev \
                        libxpm-dev \
                        libgd-dev \
                        mysql-client && \
      apt-get clean && \
      rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN update-locale LANG=ja_JP.UTF-8
