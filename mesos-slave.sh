#!/usr/bin/env bash


OPTS=""
if [ -z "$MESOS_SLAVE_IP" ]; then
    echo "No MESOS_SLAVE_IP set"
else
    echo "**** Setting Mesos Slave IP to $MESOS_SLAVE_IP"
    mkdir /etc/mesos-slave
    echo $MESOS_SLAVE_IP | tee /etc/mesos-slave/ip
    cp /etc/mesos-slave/ip /etc/mesos-slave/hostname
    OPTS="--hostname=$MESOS_SLAVE_IP --ip=$MESOS_SLAVE_IP"
fi


echo Using OPTS: $OPTS

/usr/sbin/mesos-slave $OPTS