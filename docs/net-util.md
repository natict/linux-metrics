# Network Metrics

## Network Utilization

### Task NP1: Network Utilization

1. Assuming we have two machines connected with Gigabit Ethernet interfaces, what is the maximum expected **throughput in kilo-bytes**?
2. For the following task you'll need two machines, or a partner:

	| Machine/s | Command | Notes |
	|:---------:|---------|-------|
	| A + B | `sar -n DEV 2` | Write down the receive/transmit packets/KB per-second. Keep this running for the entire length of the task |
	| A + B | `sar -n EDEV 2` | These are the error statistics, read about them in `man 1 sar`. Keep this running for the entire length of the task |
	| A | `ip a` | Write down A's IP address |
	| A | `iperf -s` | This will start a server for our little benchmark |
	| B | `iperf -c <A's address> -t 30` | Start the benchmark client for 30 seconds |
	| A | `iperf -su` | Replace the previous TCP server with a UDP one |
	| B | `iperf -c 172.30.0.251 -u -b 1000M -l 8k` | Repeat the benchmark with UDP traffic |

	1. When running the client on B, use `sar` data to determine A's link utilization (in %, assuming Gigabit Ethernet)?
	2. What are the major differences between TCP and UDP traffic observable with `sar`?
	3. Start to decrease the UDP buffer length (ie. from `8k` to `4k`, `2k`, `1k`, `512`, `128`, `64`).
		1. Does the **throughput in KB** increase or decrease?
		2. What about the **throughput in packets**?
		3. Look carefully at the `iperf` client and server report. Can you see any packet loss? Can you also see them in `ifconfig`?

### Network Errors

While Linux provides multiple metrics for network errors including- collisions, errors, and packet drops, the [kernel documentation](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net-statistics) indicates that these metrics meaning is driver specific, and tightly coupled with your underlying networking layers.

### Tools

 - Most tools use `/proc/net/dev` to fetch network device information.
	 - For example, try running `sar -n DEV <interval> <count>`.
 - Connection information for TCP, UDP and raw sockets can be fetched using `/proc/net/tcp`, `/proc/net/udp`, `/proc/net/raw`
	 - For parsed socket information use `netstat -tuwnp`.
		 - `-t`, `-u`, `-w`: TCP, UDP and raw sockets
		 - `-n`: no DNS resolving
		 - `-p`: the process owning this socket
 - The most comprehensive command-line utility is `netstat`, covering metrics from interface statistics to socket information.
 - Check `iptraf`  for interactive traffic monitoring (no socket information).
 - Finally, `nethogs` provides a `top`-like experience, allowing you to find which process is taking up the most bandwidth (TCP only).

### Discussion

- What could be the reasons for packet drops? Which of these reasons can be measured on the receiving side?
- Why can't you see the `%ifutil` value on EC2?
	- **Hint**: Network device speed is usually found in `/sys/class/net/<dev>/speed`.
	- **Workaround**: The `nicstat` utility allows you to specify the speed and duplex of your network interface from the command line:
	    ```
        nicstat -S eth0:1000fd -n 2
        ```

