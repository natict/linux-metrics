# CPU Metrics

## CPU Load
On Linux, Load Average is average the number of runnable (running + ready to run) tasks, plus tasks in uninterruptible state, in the last 1, 5, and 15 minutes.


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
Open 3 terminals (ssh connections).

1. Where are the Load Averages? Use the Linux Process States and `man 5 proc` (search for loadavg):
```bash
(term 1) root:~# man 5 proc
(term 1) root:~# cat /proc/loadavg
46.26 12.59 4.39 1/106 7023
```
2. Start the disk stress script (**NOTE: Do not run this on your own laptop !!!**):

```bash
(term 1) root:~# /bin/sh linux-metrics/scripts/disk/writer.sh
```

3. Run the following command and look at the Load values for about a minute until `ldavg-1` stabilizes:

```bash
(term 2) root:~# sar -q 1 100
```
* What is the writing speed of the script?
* What is the current Load Average? Why? Which processes contribute to this number?
```bash
(term 2) root:~# top
```
* What are CPU `%user`, `%sy`, `%IO-wait` and `%idle`?

4. While the previous script is running, start a single CPU stress:

```bash
(term 3) root:~# stress -c 1 -t 3600
```
Wait another minute, and answer the above questions above.

5. Stop all scripts.

### Discussion

- Why are processes waiting for IO included in the Load Average?
- Assuming we have 1 CPU core and Load of 5, is our CPU core on 100% utilization?
- How can we know if load is going up or down?
- Does a load average of 70 indicate a problem?

### Further reading
- [Understanding Linux CPU Load](http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages)

## Tools

 - Most tools use `/proc/loadavg` to fetch Load Average and run queue information.
 - To get a percentage over a specific interval of time, you can use:
	 - `sar -q <interval> <count>`
		 - `-q` queue length and load averages
	 - or  simply `uptime`

#### Next: [Context Switches](cpu-ctxt.md)
