FROM centos:7

# OCI annotations to image
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="CentOS Base Image" \
    org.opencontainers.image.description="Docker Images for CentOS. (i386,amd64,arm32v5,arm32v7,arm64,mips64le,ppc64le,s390x)" \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/centos" \
    org.opencontainers.image.base.name="snowdreamtech/centos:latest" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/centos" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="12.7" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/centos"

# keep the docker container running
ENV KEEPALIVE=0 \
    # Ensure the container exec commands handle range of utf8 characters based of
    # default locales in base image (https://github.com/docker-library/docs/tree/master/centos#locales)
    LANG=C.UTF-8 

RUN set -eux \
    && sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org/centos/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
    -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos-vault/7.9.2009|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo \
    && yum -y update \
    && yum -y install \
    sudo \
    vim \ 
    unzip \
    tzdata \
    openssl \
    wget \
    curl \
    lsof \
    && wget -c http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm \
    && rpm -ivh mysql-community-release-el7-5.noarch.rpm \
    && rm mysql-community-release-el7-5.noarch.rpm \
    && yum -y update \
    && yum -y install \
    mysql-server \
    && yum clean all 

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]