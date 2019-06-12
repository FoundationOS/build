FROM ubuntu:16.04

RUN dpkg --add-architecture i386

# native platform development and build system functionality (about 400 MB installed)
RUN apt-get update && apt-get -y install \
    sudo \
    dialog \
    bsdmainutils \
    build-essential \
    curl \
    cppcheck \
    doxygen \
    libpcre3 \
    pcregrep \
    python3 \
    dialog \
    python-m2crypto \
    unzip \
    wget \
    chrpath \
    gawk \
    u-boot-tools \
    diffstat \
    pkg-config \
    cpio \
    libncurses5-dev \
    texinfo \
    git  \
    iputils-ping \
    dosfstools \
    mtools  \
    android-tools-fsutils \
    locales

RUN apt-get -y install \
    g++-multilib \
    libssl-dev:i386 \
    libcrypto++-dev:i386 \
    zlib1g-dev:i386

RUN apt-get -y install \
    vim \
    tmux

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

COPY init.sh /usr/bin/init.sh
RUN  chmod +x /usr/bin/init.sh

