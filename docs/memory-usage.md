# Memory Metrics

## Memory Usage

Is free memory really free? What's the difference between cached memory and buffers? Why can't I dump all the caches? Let's get our hands dirty and find out...

You will need 3 open terminals for this task. **DO NOT RUN THESE SCRIPTS ON YOUR LAPTOP!**

### Task M1: Memory usage, Caches and Buffers

1. Fire up `top` on Terminal 1, and write down how much `free` memory you have (**keep it running for the rest of this module**)
2. Start the memory hog `scripts/memory/hog.sh` on Terminal 2, let it run until it gets killed (if it hangs- use `Ctrl+c`)
3. Go to Terminal 1 and compare that to the number you wrote. Are they (almost) the same? If not, why?
4. Read about the `buffer` and `cached Mem`  values in `man 5 proc` (under `meminfo`)
	1. Run the memory hog on Terminal 2 `scripts/memory/hog.sh`
	2. Write down the `buffer` size from Terminal 1
	3. Now run the buffer balloon `sudo scripts/memory/buffer.sh` on Terminal 2
	4. Check the `buffer` size again 
	5. Read the script, and see if you can make sense of the results...
	6. Repeat the 5 steps above with the `cached Mem` value and  `sudo scripts/memory/cache.sh`
5. Let's see how `cached Mem` affects application performance
	1. As *root*, drop the cache using `echo 3 > /proc/sys/vm/drop_caches`
	2. Time a dummy Python application `time python -c 'print "Hello World"'` (you can repeat these 2 steps multiple times)
	3. Now re-run our dummy Python application, but this time without flushing the cached memory. Can you see the difference?
6. Run the `memory/dentry.py` script and observe the memory usage using `free`. What is using the memory? How does it effect performance? 
7. Run the `memory/dentry2.py` script and try dropping the caches. Does it make a difference? what's the difference between `dentry.py` and `dentry2.py`?

### Discussion

- Why wasn't our memory hog able to grab all the `cached` memory?
- What will happen if we remove the following line from `scripts/memory/hog.sh` (Try it!)? Why?

	```c
	tmp[0] = 0;
	```

- Assuming a server has some amount of free memory, can we assume it has enough memory to support it's current workload? If not, why?
- Run `stress -m 18 --vm-bytes 100M  -t 600s`. What do you see?


### Tools

 - Most tools use `/proc/meminfo` to fetch memory usage information.
	 - A simple example is the `free` utility
 - To get usage information over some period, use `sar -r <delay> <count>`
	 - Here you can also see how many dirty pages you have (try running `sync` while `sar` is running)
	 - The `%commit` field is also interesting, especially if it's larger than 100...

#### Next: [IO Usage](io-usage.md)
