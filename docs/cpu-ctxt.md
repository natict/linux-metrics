# CPU Metrics

## Context Switches

### Recall: Linux Process Context Switches
A mechanism to store current process *state* ie. Registers, Memory maps, Kernel structs (eg. TSS in 32bit), and load another (or a new one). Context switches are usually computationally expensive (although optimization exist), yet inevitable. For example, they are used to allow multi-tasking (eg. preemption), and to switch between user and kernel modes.

### Task CS1: Context Switches

1. Execute `vmstat 2` and write down the current context switch rate (`cs` field)
2. Raise that number by executing `stress -i 10`
	1. What is the current context switch rate?
	2. What is causing this rate? Multi-tasking? Interrupts? Switches between kernel and user modes?
	3. Kill the `stress` command, and watch the rate drop
3. Now let's see how a high context switch rate affects a dummy application
	1. Run the dummy application `perf stat -e cs python scripts/cpu/dummy_app.py` (which calls a dummy function 1000 times, and prints it's runtime percentile)
	2. Write the current CPU usage, the application percentiles and context switch rate
	3. **In the same session**, raise the context switch rate using `stress -i 10 &` and re-run the dummy application. Write the current CPU usage, the application percentiles and context switch rate.
	4. Describe the change in the percentiles. Did the high context switch rate affect most of `foo()` runs (ie. the 50th percentile)? If not, why?
4. Finally, make sure that what you're looking at is context switching overhead, and not scheduling
	1. Retry this experiment, this time using `stress -d 10 --hdd-bytes 1k &`
	2. Compare the CPU usage to **3.iii** (it should be roughly the same) and compare the context switch rate (which should be lower now)
	3. Re-run the dummy application and describe the change in the percentiles vs **3.iv**

### Discussion

- Can performance measurements on a staging environment truly estimate performance on production?
- Why did we run the `stress` command and our dummy application in the same session?
	- Read about the [magic kernel patch](http://www.phoronix.com/scan.php?page=article&item=linux_2637_video&num=1)

### Tools

 - Most tools use `/proc/vmstat` to fetch global context switching information (`ctxt` field), and `/proc/[PID]/status` for process specific information (`voluntary_context_switches` and `nonvoluntary_context_switches` fields)
 - From the command-line you can use
	 - `vmstat <delay> <count>` for global information
	 - `pidstat -w -p <pid> <delay> <count>` for process specific information

#### Next: [Memory Usage](memory-usage.md)
