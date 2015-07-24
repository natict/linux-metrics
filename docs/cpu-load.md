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
2. Start the disk stress script (NOTE: avoid running it on your own SSD):

	```bash
	scripts/disk/writer.sh
	```

3. Look at the Load values for about a minute until `ldavg-1` stabilizes:

	```bash
	sar -q 1 100
	```

	1. What is the writing speed of our script (ignore the first value, this is [EBS General Purpose IOPS Burst](http://aws.amazon.com/ebs/details/#GP))?
	2. What is the current Load Average? why? which processes are contributing to this number?
	3. What are the CPU %user, %IO-wait and %idle?
4. While the previous script is running, start a single CPU stress:

	```bash
	stress -c 1 -t 3600
	```
	Wait for another minute, and re-answer the questions above.
5. Stop all the scripts

### Discussion

- Why do you think processes waiting for IO are included in the Load Average?
- Assuming we have 1 CPU core and Load of 5, is our CPU core on 100% utilization?

### Tools

 - Most tools are using `/proc/loadavg` to fetch Load Average and run queue information.
 - To get a percentage over a specific interval of time, you can use:
	 - `sar -q <interval> <count>`
		 - `-q` queue length and load averages
	 - or  simply `uptime`

#### Next: [Memory Usage](memory-usage.md)
