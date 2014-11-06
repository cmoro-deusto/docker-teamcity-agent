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
RUN groupadd teamcity
RUN useradd teamcity -m -g teamcity -s /bin/bash
RUN passwd -d -u teamcity
RUN echo "teamcity ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/teamcity
RUN chmod 0440 /etc/sudoers.d/teamcity


EXPOSE 9090
USER teamcity
WORKDIR /home/teamcity
CMD sudo -u teamcity -s -- sh -c "TEAMCITY_SERVER=$TEAMCITY_SERVER bash /setup-agent.sh run"
