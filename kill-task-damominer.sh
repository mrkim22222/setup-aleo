#!/bin/sh
SERVICE='damominer'

if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
    echo "$SERVICE service running, killing --> $SERVICE"
    kill $(ps -AF | grep $SERVICE | grep -v grep | awk '{print $2}')
else
    echo "$SERVICE is not running"
fi
