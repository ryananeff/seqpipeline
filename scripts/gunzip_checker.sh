#!/bin/sh
COUNTER=1
while [ $COUNTER ]; do
        clear
        for f in ~/1000g/*.gz; do
                qsub -b y -N extract -o /dev/null -e /dev/null "gunzip $f"
        done
        qsub -sync y -hold_jid extract -b y -o /dev/null -e /dev/null "echo round complete"
        sleep 10 # protect queue in case things get out of control
done

