FROM ubuntu:14.04.1

MAINTAINER Carlos Moro <dordoka@gmail.com>

ADD setup-agent.sh /setup-agent.sh

# Fix add-apt-repo in ubuntu docker
RUN apt-get update && \
    apt-get install -y software-properties-common

# Install Java and dependencies
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer wget unzip && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN adduser teamcity


EXPOSE 9090
CMD sudo -u teamcity -s -- sh -c "TEAMCITY_SERVER=$TEAMCITY_SERVER bash /setup-agent.sh run"
