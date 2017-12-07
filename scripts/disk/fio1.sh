#!/bin/sh

fio --directory=/tmp --name fio_test_file --direct=1 --rw=randwrite --bs=16k --size=100M --numjobs=16 --time_based --runtime=180 --group_reporting --norandommap
