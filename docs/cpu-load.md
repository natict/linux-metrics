# CPU Metrics

## CPU Load

### Recall: Linux Process State

From `man 1 ps`:
```
D    uninterruptible sleep (usually IO)
R    running or runnable (on run queue)
S    interruptible sleep (waiting for an event to complete)
T    stopped, either by a job control signal or because it is being traced
Z    defunct ("zombie") process, terminated but not reaped by its parent
```

### Task CL1: CPU Load

1. What is the Load Average metric? Use the Linux Process States and `man 5 proc` (search for loadavg)
```
root@snf-6933:~# man 5 proc
root@snf-6933:~# cat /proc/loadavg
46.26 12.59 4.39 1/106 7023
```
2. Start the disk stress script (NOTE: Do not run it on your own laptop !!!):

```bash
root@snf-6933:~# cd linux-metrics
root@snf-6933:~# ./scripts/disk/writer.sh 
```

3. Run the following command and look at the Load values for about a minute until `ldavg-1` stabilizes:

	```bash
	sar -q 1 100
	```

	1. What is the writing speed of our script (ignore the first value, this is [EBS General Purpose IOPS Burst](http://aws.amazon.com/ebs/details/#GP))?
	2. What is the current Load Average? Why? Which processes contribute to this number?
	3. What are CPU %user, %IO-wait and %idle?
4. While the previous script is running, start a single CPU stress:

	```bash
	stress -c 1 -t 3600
	```
	Wait another minute, and answer the questions above again.
5. Stop all the scripts

### Discussion

- Why are processes waiting for IO included in the Load Average?
- Assuming we have 1 CPU core and Load of 5, is our CPU core on 100% utilization?
- How can we know if load is going up or down?
- Does a load average of 70 indicate a problem?

### Tools

 - Most tools use `/proc/loadavg` to fetch Load Average and run queue information.
 - To get a percentage over a specific interval of time, you can use:
	 - `sar -q <interval> <count>`
		 - `-q` queue length and load averages
	 - or  simply `uptime`

#### Next: [Context Switches](cpu-ctxt.md)
