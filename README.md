# Linux Metrics Workshop
While you can learn a lot by emitting metrics from your application, some insights can only be gained by looking at OS metrics. In this hands-on workshop, we will cover the basics in Linux metric collection for monitoring, performance tuning and capacity planning.

## Topics
1. CPU
  1. [CPU Percentage](docs/cpu-percentage.md)
  2. [CPU Load](docs/cpu-load.md)
  3. [Context Switches](docs/cpu-ctxt.md)
2. Memory
  1. [Memory Usage](docs/memory-usage.md)
3. IO
  1. [IO Usage](docs/io-usage.md)
4. Network
  1. [Network Utilization](docs/net-util.md)

## Setup
The workshop was designed to run on AWS EC2 t2.small instance with general purpose SSD, running Ubuntu 14.04 amd64 with transparent hugh pages disabled.
You can build an AMI with all the dependencies installed using the attached [packer](https://www.packer.io/) template.

## References
- [here](docs/references.md)
