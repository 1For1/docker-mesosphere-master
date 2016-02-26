#!/usr/bin/env bash


if [ -z "$MESOS_MASTER_IP" ]; then
    echo "No MESOS_MASTER_IP set"
else
    echo "**** Setting Mesos Master IP to $MESOS_MASTER_IP"
    mkdir /etc/mesos-master
    echo $MESOS_MASTER_IP | tee /etc/mesos-master/ip
    cp /etc/mesos-master/ip /etc/mesos-master/hostname
fi


/usr/sbin/mesos-master