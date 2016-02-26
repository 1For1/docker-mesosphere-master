FROM oneforone/docker-mesosphere-base

MAINTAINER 1for.one <ops@1for.one>

# Installing zookeeper.  Seems to be a dependancy to mesos
# Not going to start it on runtime though
RUN sudo apt-get -y install zookeeperd
RUN echo 1 | sudo dd of=/var/lib/zookeeper/myid

# Install mesos.
RUN sudo apt-get -y install mesos
RUN sudo mkdir -p /etc/mesos-master
RUN echo in_memory | sudo dd of=/etc/mesos-master/registry

EXPOSE 5050

ENV MESOS_HOSTNAME="localhost" MESOS_IP="127.0.0.1" MESOS_ZK="zk://localhost:2181/mesos" MESOS_LOG_DIR="/var/log/mesos" MESOS_QUORUM=1 MESOS_REGISTRY="in_memory" MESOS_WORK_DIR="/var/lib/mesos"

ENTRYPOINT ["mesos-master"]