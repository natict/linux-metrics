# IO Metrics

## IO Usage

### Recall: Linux IO, Merges, IOPS

Linux IO performance is affected by many factors, including your application workload, choice of file-system, IO scheduler choice (eg. [cfq](https://www.kernel.org/doc/Documentation/block/cfq-iosched.txt), [deadline](https://www.kernel.org/doc/Documentation/block/deadline-iosched.txt)), queue configuration, device driver, underlying device(s) caches and more.

![Linux IO](images/linux_io.png)

#### Merged Reads/Writes

From [the Kernel Documentation](https://www.kernel.org/doc/Documentation/iostats.txt): *"Reads and writes which are adjacent to each other may be merged for efficiency.  Thus two 4K reads may become one 8K read before it is ultimately handed to the disk, and so it will be counted (and queued) as only one I/O"*

#### IOPS

IOPS are input/output operations per second. Some operations take longer than other, eg. HDDs can do a sequential reading operations much faster than random writing operations. Here are some rough estimations [from Wikipedia](https://en.wikipedia.org/wiki/IOPS) and [Amazon EBS Product Details](http://aws.amazon.com/ebs/details/):
| Device/Type           | IOPS      |
|-----------------------|-----------|
| 7.2k-10k RPM SATA HDD | 75-150    |
| 10k-15k RPM SAS HDD   | 140-210   |
| SATA SSD              | 1k-120k   |
| AWS EC2 gp2           | up to 10k |
| AWS EC2 io1           | up to 20k |


### Task I1: IO Usage

1. Start by running `iostat -xd 2`, and look at the output fields, let's go over the important ones together:
	- **rrqm/s** & **wrqm/s**- How many read/write requests merged per-second
	- **r/s** & **w/s**- Read/Write requests (after merges) per-second. Their sum is the IOPS!
	- **rkB/s** & **wkB/s**- Number of kB read/written per-second, ie. **IO throughput**.
	- **avgqu-sz**- Average requests queue size for this device. Check out `/sys/block/<device>/queue/nr_requests` for the maximum queue size.
	- **r_await**, **w_await**, **await**- The average time (in ms.) for read/write/both requests to be served, including time spent in the queue, ie. **IO latency**
2. Please write down these field's values when our system at rest
3. Now, in a new session, let's benchmark our device *write performance* by running:

	```bash
	fio --directory=/tmp --name fio_test_file --direct=1 --rw=randwrite --bs=16k --size=100M --numjobs=16 --time_based --runtime=180 --group_reporting --norandommap
	```
	
	This will clone 16 processes to perform non-buffered (direct) random writes for 3 minutes.
	1. Compare the values you see in `iostat` to the values you wrote down earlier. Do they make sense? 
	2. Look at `fio` results and try to see if the number of IOPS make sense (we are using EBS gp2 volumes).
4. Repeat the previous task, this time benchmark **read performance**:

	```bash
	fio --directory=/tmp --name fio_test_file --direct=1 --rw=randread --bs=16k --size=100M --numjobs=16 --time_based --runtime=180 --group_reporting --norandommap
	```
	
5. `fio` also support other IO patterns (by changing the `--rw=` parameter), including:
	- `read` Sequential reads
	- `write` Sequential reads
	- `rw` Mixed sequential reads and writes
	- `randrw` Mixed random reads and writes

	If time permits, explore these IO patterns, to learn more about EBS gp2's performance under different workloads.

### Discussion

- Why do we need an IO queue? what does it allow the kernel to perform?
- Why the `svctm` and `%util` iostat fields are essentially useless in a modern environment?

### Tools

 - Most tools are using `/proc/diskstats` to fetch global IO statistics.
 - Per-process IO statistics are usually fetched from `/proc/[pid]/io`, which is documented in `man 5 proc`
 - From the command-line you can use
	 - `iostat -xd <delay> <count>` for per-device information
		 - `-d` device utilization
		 - `-x` extended statistics
	 - `sudo iotop` for a `top`-like interface (easily find process doing most reads/writes)
		 - `-o` only show processes or threads actually doing I/O
