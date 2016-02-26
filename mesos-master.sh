#!/usr/bin/env bash


OPTS=""
if [ -z "$MESOS_MASTER_IP" ]; then
    echo "No MESOS_MASTER_IP set"
else
    echo "**** Setting Mesos Master IP to $MESOS_MASTER_IP"
    mkdir /etc/mesos-master
    echo $MESOS_MASTER_IP | tee /etc/mesos-master/ip
    cp /etc/mesos-master/ip /etc/mesos-master/hostname
    OPTS="--hostname=$MESOS_MASTER_IP --ip=$MESOS_MASTER_IP"
fi


echo Using OPTS: $OPTS

/usr/sbin/mesos-master $OPTS