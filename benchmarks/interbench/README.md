# Interbench - The Linux Interactivity Benchmark

#### Docker Image
[![](https://images.microbadger.com/badges/image/ljishen/interbench.svg)](http://microbadger.com/images/ljishen/interbench "Get your own image badge on microbadger.com")

#### Usage
```bash
docker run --rm \
    --cap-add=SYS_NICE \
    -v `pwd`:/root/results \
    ljishen/interbench \
    /root/results/output.prof
```

###### These are appendable arguments
```
 -l     Use <int> loops per sec (default: use saved benchmark)
 -L     Use cpu load of <int> with burn load (default: 4)
 -t     Seconds to run each benchmark (default: 30)
 -B     Nice the benchmarked thread to <int> (default: 0)
 -N     Nice the load thread to <int> (default: 0)
 -b     Benchmark loops_per_ms even if it is already known
 -c     Output to console only (default: use console and logfile)
 -r     Perform real time scheduling benchmarks (default: non-rt)
 -C     Use <int> percentage cpu as a custom load (default: no custom load)
 -I     Use <int> microsecond intervals for custom load (needs -C as well)
 -m     Add <comment> to the log file as a separate line
 -w     Add <load type> to the list of loads to be tested against
 -x     Exclude <load type> from the list of loads to be tested against
 -W     Add <bench> to the list of benchmarks to be tested
 -X     Exclude <bench> from the list of benchmarks to be tested
 -h     Show this help

If run without parameters interbench will run a standard benchmark

Recommend to run as root and set -L to number of CPUs on the system
```

The default execution performs real time scheduling benchmarks and uses cpu load of 1 with burn load.

See [Homepage](https://github.com/ckolivas/interbench) of The Linux Interactivity Benchmark for more details.
