# CPU Metrics

## CPU Percentage
Let's start with the most common CPU metric.
Fire up `top`, and let's start figuring out what are the different CPU percentage values.
```
%Cpu(s):  2.3 us,  0.6 sy,  0.0 ni, 96.7 id,  0.2 wa
```

### Task CP1: CPU Percentage
For each one of the 4 scripts under the `scripts/cpu/` directory (ie. `dummy1.sh`, `dummy2.sh`, `dummy3.sh`, `dummy4.sh` ):

 1. Run the script
 2. While the script is running, look at `top` on another terminal
 3. Without looking at the code, try to figure out what the script is doing (you can use `man 1 top`) 
 4. Stop the script (use `Ctrl+C` or let it timeout after 2 minutes)
 5. Read the script content and verify your answer

### Tools

 - Most tools are using `/proc/stat` to fetch CPU percentage. Note that it displays amount of time and not percentage.
 - To get a percentage over a specific interval of time, you can use:
	 - `sar -P ALL -u <interval> <count>`
		 - `-P` per-processor statistics
		 - `-u` CPU utilization
	 - or  `mpstat` (similar usage and output)

### Discussion

- What is the difference between %IO-wait and %idle?

#### Time Stolen and Amazon EC2
You might have noticed the `st` label. From `man 1 top`:
```
st : time stolen from this vm by the hypervisor
```
Amazon EC2 is using the hypervisor to regulate the machine CPU usage (to match the instance type's EC2 Compute Units). If you are seeing inconsistent stolen percentage over time, then you might be using [Burstable Performance Instances](http://aws.amazon.com/ec2/instance-types/#burst).

#### Next: [CPU Load](cpu-load.md)
