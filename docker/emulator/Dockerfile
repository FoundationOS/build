FROM ubuntu:16.04

RUN apt-get update 
RUN apt-get install -y qemu iptables sudo locales

# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

COPY init.sh /usr/bin/init.sh
RUN  chmod +x /usr/bin/init.sh
