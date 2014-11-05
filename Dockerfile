FROM ariya/centos7-oracle-jre7

MAINTAINER Carlos Moro <dordoka@gmail.com>

ADD setup-agent.sh /setup-agent.sh
RUN yum -y install wget unzip sudo
RUN adduser teamcity

EXPOSE 9090
CMD sudo -u teamcity -s -- sh -c "TEAMCITY_SERVER=$TEAMCITY_SERVER bash /setup-agent.sh run"
