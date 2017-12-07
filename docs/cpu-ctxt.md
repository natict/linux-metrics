# CPU Metrics

You will need 3 ssh terminals

## Context Switches

### Recall: Linux Process Context Switches
A mechanism to store current process *state* ie. Registers, Memory maps, Kernel structs (eg. TSS in 32bit), and load another (or a new one). Context switches are usually computationally expensive (although optimization exist), yet inevitable. For example, they are used to allow multi-tasking (eg. preemption), and to switch between user and kernel modes.

Interprocess context switches are classified as *voluntary* or *involuntary*. A voluntary context switch occurs when a thread blocks because it
requires a resource that is unavailable. An involuntary context switch takes place when a thread executes for the duration of its time slice or when
the system identifies a higher-priority thread to run.

### Task CS1: Context Switches

1. Execute `vmstat 2` in a session (#1) and write down the current context switch rate (`cs` field):
   ```bash
   (term 1) root:~# vmstat 2
   ```
2. Raise that number by executing `stress -i 10` in a new session (#2):
   ```bash
   (term 2) root:~# stress -i 10
   ```
	1. What is the current context switch rate?
	2. What is causing this rate? Multi-tasking? Interrupts? Switches between kernel and user modes?
	3. Kill the `stress` command in session #2, and watch the rate drop.
3. Now let's see how a high context switch rate affects a dummy application.
	1. On session #2 run the dummy application `dummy_app.py` (which calls a dummy function 5000 times, and prints it's runtime percentiles):
   ```bash
   (term 2) root:~# perf stat -e cs python linux-metrics/scripts/cpu/dummy_app.py
   ```
	2. Write the current CPU usage, the application percentiles and context switch rate.
	3. **In the same session (#2)**, raise the context switch rate using `stress -i 10 -t 150 &` and re-run the dummy application. Write the current CPU usage, the application percentiles and context switch rate.
   ```bash
   (term 2) root:~# stress -i 10 -t 150 &
   (term 2) root:~# perf stat -e cs python linux-metrics/scripts/cpu/dummy_app.py
   ```
	4. Describe the change in the percentiles. Did the high context switch rate affect most of `foo()` runs (ie. the 50th percentile)? If not, why?
4. Observe the behaviour when running `stress` in a different scheduling task group:
	1. Open a new session (#3) and move it to a different cgroup:
   ```bash
   (term 3) root:~# mkdir -p /sys/fs/cgroup/cpu/grp/c; echo $$ | sudo tee /sys/fs/cgroup/cpu/grp/c/tasks
   ```
	2. Run stress again in the new session (#3) `stress -i 10 -t 150` or `stress -c 10 -t 150`:
   ```bash
   (term 3) root:~# stress -i 10 -t 150
   ```
	3. Compare the CPU usage to **3.iii** (it should be roughly the same) and compare the context switch rate (which should be the same).
	4. Re-run the dummy application in the previous session (#2) and describe the change in the percentiles (and process context switch) vs **3.iv**.
5. What happens when processes compete for cpu time under a cgroup hierarchy?
	1. Move the second session to a new cgroup:
   ```bash
   (term 2) root:~# mkdir -p /sys/fs/cgroup/cpu/grp/b; echo $$ | sudo tee /sys/fs/cgroup/cpu/grp/b/tasks
   ```
	2. Run `stress` in session #2 and `perf dummy_app.py` in session #3. What do you observe?
   ```bash
   (term 2) root:~# stress -i 10 -t 150
   (term 3) root:~# perf stat -e cs python linux-metrics/scripts/cpu/dummy_app.py
   ```
	2. Lower cpu.shares for stress cgroup (#2) and raise for cgroup (#3):
   ```bash
   (term 2) root:~# echo 200 > /sys/fs/cgroup/cpu/grp/b/cpu.shares
   (term 3) root:~# echo 1000 > /sys/fs/cgroup/cpu/grp/c/cpu.shares
   ```
	3. In session #2 run `stress` again and in session #3 run the `perf dummy_app.py`:
   ```bash
   (term 2) root:~# stress -i 10 -t 150
   (term 3) root:~# perf stat -e cs python linux-metrics/scripts/cpu/dummy_app.py
   ```
	4. What do you observe?

### Discussion

- Can performance measurements on a staging environment truly estimate performance on production?
- Why did we run the `stress` command and our dummy application in the same session?

### Tools

 - Most tools use `/proc/vmstat` to fetch global context switching information (`ctxt` field), and `/proc/[PID]/status` for process specific information (`voluntary_context_switches` and `nonvoluntary_context_switches` fields).
 - From the command-line you can use:
	 - `vmstat <delay> <count>` for global information.
	 - `pidstat -w -p <pid> <delay> <count>` for process specific information (voluntary/involuntary context switches).

### Further reading

- `man sched`
- http://www.linfo.org/context_switch.html
- https://wiki.archlinux.org/index.php/cgroups

#### Next: [Memory Usage](memory-usage.md)
