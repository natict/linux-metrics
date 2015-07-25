# Memory Metrics

## Memory Usage

Is free memory really free? What's the difference between cached memory and buffers? Why can't I dump all the caches? Let's get our hands dirty and find out...

### Task M1: Memory usage, Caches and Buffers

1. Fire up `top`, and write down how much `free` memory you have
2. Start the memory hog `scripts/memory/hog.sh`, let it run until it get killed (if it hangs- use `Ctrl+c`)
3. Compare that to the number you wrote. Are they (almost) the same? If not, why?
4. Read about the `buffer` and `cached Mem`  values in `man 5 proc` (under `meminfo`)
	1. Run the memory hog `scripts/memory/hog.sh`
	2. Write down the `buffer` size
	3. Now run the buffer balloon `scripts/memory/buffer.sh`
	4. Check the `buffer` size again
	5. Read the script, and see if you can make sense of the results...
	6. Repeat the 5 steps above with the `cached Mem` value and  `scripts/memory/buffer.sh`
5. Finally, let's see how `cached Mem` affects application performance
	1. As *root*, drop the cache using `echo 3 > /proc/sys/vm/drop_caches`
	2. Time a dummy Python application `time python -c 'print "Hello World"'` (you can repeat these 2 steps multiple times)
	3. Now re-run our dummy Python application, but this time without flushing the cached memory. Can you see the difference?

### Discussion

- Why wasn't our memory hog able to grab all the `cached` memory?
- What will happen if we remove the following line from `scripts/memory/hog.sh` (Try it!)? Why?

	```c
	tmp[0] = 0;
	```

- If we have some amount of free memory, do we have enough memory to support our current workload? If not, why?


### Tools

 - Most tools are using `/proc/meminfo` to fetch memory usage information.
	 - A simple example is the `free` utility
 - To get usage information over some period, use `sar -r <delay> <count>`
	 - Here you can also see how many dirty pages you have (try running `sync` while `sar` is running)
	 - The `%commit` field is also interesting, especially if it's larger than 100...

#### Next: [IO Usage](io-usage.md)
