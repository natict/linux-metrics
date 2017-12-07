#!/bin/sh

fio --directory=/tmp --name fio_test_file --direct=1 --rw=randread --bs=16k --size=100M --numjobs=1 --time_based --runtime=180 --group_reporting --norandommap
