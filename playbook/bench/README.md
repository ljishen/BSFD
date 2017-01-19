# Playbook for Running Benchmarks on Hosts

Benchmarks can be run on both "docker compatible" and "docker incompatible" (e.g. bare metal). Please look at the inventory file (hosts).

This playbook has three roles:
- **bench** - run benchmark on all hosts according to the command file (`roles/bench/vars/main.yml`), and collect result profiles to localhost
- **parse** - parse all result profiles and merge them into a CSV file by using each `parse.sh` script in the benchmark folder.
- **show** - get ready to visualize all benchmark results by launching a scipy-notebook docker container

### Usage
1. Install roles included in requirements.yml
    ```bash
    ansible-galaxy install -r requirements.yml
    ```

1. This playbook contains file I/O benchmarks by default. Please ensure,
    - Your **Docker storage driver** is on top of a storage device with **CFQ (Completely Fair Queuing) scheduler**. See [1](http://unix.stackexchange.com/questions/69300/cgroups-blkio-weight-doesnt-seem-to-have-the-expected-effect), [2](https://www.cyberciti.biz/faq/linux-change-io-scheduler-for-harddisk/) if you don't know how to check or change.
    - The **drive write-caching (write-back caching)** setting is same. See [here](http://www.linux-magazine.com/Online/Features/Tune-Your-Hard-Disk-with-hdparm).

1. Check all the hosts in the inventory file (hosts), then
    ```bash
    ansible-playbook --forks=1 bench.yml
    ```
