# CPU Metrics

You will need 3 ssh terminals

## CPU Percentage
Let's start with the most common CPU metric.
Fire up `top`, and let's start figuring out what the different CPU percentage values are.
```bash
(term 1) root:~# top
```

The output will look like:
```bash
%Cpu(s):  2.3 us,  0.6 sy,  0.0 ni, 96.7 id,  0.2 wa,  0.0 hi,  0.0 si,  0.0 st
```

### Task CP1: CPU Percentage
For each of the following scripts (`dummy1.sh`, `dummy2.sh`, `dummy3.sh`, `dummy4.sh`) under the `scripts/cpu/` directory:

 1. Run the script:
```bash
(term 2) root:~# /bin/sh linux-metrics/scripts/cpu/dummy1.sh
```
 2. While the script is running, look at `top` on terminal window 1.
 3. Without looking at the code, try to figure out what the script is doing (find the percentage fields description in `man 1 top`)
 4. Stop the script (use `Ctrl+C` or wait 2 minutes for it to timeout)
 5. Verify your answer by reading the script content

### Tools

 - Most tools use `/proc/stat` to fetch CPU percentage. Note that it displays amount of time measured in units of USER_HZ
   (1/100ths of a second on most architectures), also called jiffies, and not percentage.
 - To get a percentage over a specific interval of time, you can use:
	 - `sar <interval> <count>`
	 - or  `sar -P ALL -u <interval> <count>` (for details on multiple cpus)
		 - `-P` per-processor statistics
		 - `-u` CPU utilization
	 - or  `mpstat` (similar usage and output)
```bash
(term 3) root:~# sar 1
```
or
```bash
(term 3) root:~# mpstat 1
```

### Discussion

- What's the difference between `%IO-wait` and `%idle`?
- Is the entire CPU load created by a process accounted to that process?

### Further reading

- `man proc`
- `man sar`

#### Time Stolen and Amazon EC2

You may have noticed the `st` label. From `man 1 top`:
```
st : time stolen from this vm by the hypervisor
```
Amazon EC2 uses the hypervisor to regulate the machine CPU usage (to match the instance type's EC2 Compute Units). If you see inconsistent stolen percentage over time, then you might be using [Burstable Performance Instances](http://aws.amazon.com/ec2/instance-types/#burst).

#### Next: [CPU Load](cpu-load.md)
