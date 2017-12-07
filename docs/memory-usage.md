# Memory Metrics

## Memory Usage

Is free memory really free? What's the difference between cached memory and buffers? Let's get our hands dirty and find out...

You will need 3 open terminals for this task. **DO NOT RUN ANY SCRIPTS ON YOUR LAPTOP!**

### Task M1: Memory usage, Caches and Buffers

1. Fire up `top` on Terminal 1, and write down how much `free` memory you have (**keep it running for the rest of this module**):
    ```bash
    (term 1) root:~# top
    ```
2. Start the memory hog `hog.sh` on Terminal 2, let it run until it gets killed (if it hangs- use `Ctrl+c`):
    ```bash
    (term 2) root:~# /bin/sh linux-metrics/scripts/memory/hog.sh
    ```
3. Go to Terminal 1 and compare that to the number you wrote. Are they (almost) the same? If not, why?
4. Read about the `Buffers` and `Cached`  values in `man 5 proc` (under `meminfo`):
	1. Run the memory hog on Terminal 2 `scripts/memory/hog.sh`:
    ```bash
    (term 2) root:~# /bin/sh linux-metrics/scripts/memory/hog.sh
    ```
	2. Write down the `buffer` size from Terminal 1.
	3. Now run the buffer balloon `buffer.sh` on Terminal 2:
    ```bash
    (term 2) root:~# /bin/sh linux-metrics/scripts/memory/buffer.sh
    ```
	4. Check the `buffer` size again.
	5. Read the script, and see if you can make sense of the results.
	6. Repeat all 5 steps above with the `cached Mem` value.
    7. Repeat all steps for `cache.sh`:
    ```bash
    (term 2) root:~# /bin/sh linux-metrics/scripts/memory/cache.sh
    ```
5. Let's see how `cached Mem` affects application performance:
	1. Drop the cache:
    ```bash
    (term 2) root:~# echo 3 > /proc/sys/vm/drop_caches
    ``` 
	2. Time a dummy Python application (you can repeat these 2 steps multiple times):
    ```bash
    (term 2) root:~# time python -c 'print "Hello World"'
    ```
	3. Now re-run our dummy Python application, but this time without flushing the cached memory. Can you see the difference?
6. Run the `dentry.py` script and observe the memory usage using `free`. What is using the memory? How does it effect performance?
    ```bash
    (term 2) root:~# python linux-metrics/scripts/memory/dentry.py
    (term 2) root:~# echo 3 > /proc/sys/vm/drop_caches
    (term 2) root:~# time ls trash/ >/dev/null
    (term 2) root:~# time ls trash/ >/dev/null
    ```
7. Run the `dentry2.py` script and try dropping the caches. Does it make a difference?
    ```bash
    (term 2) root:~# python linux-metrics/scripts/memory/dentry2.py
    ```

### Discussion

- What's the difference between `dentry.py` and `dentry2.py`?
- Assuming a server has some amount of free memory, can we assume it has enough memory to support it's current workload? If not, why?
- Why wasn't our memory hog able to grab all the `cached` memory?
- Run the following stress test, what do you see?
  ```bash
  (term 2) root:~# stress -m 18 --vm-bytes 100M  -t 600s
  ```


### Tools

 - Most tools use `/proc/meminfo` to fetch memory usage information.
	 - A simple example is the `free` utility.
     - What does the 2nd line of `free` tell us?
 - To get usage information over some period, use `sar -r <delay> <count>`.
	 - Here you can also see how many dirty pages you have (try running `sync` while `sar` is running).

#### Next: [IO Usage](io-usage.md)
