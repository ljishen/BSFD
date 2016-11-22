# Playbook for Running Benchmarks on Hosts

Benchmarks can be run on both "docker compatible" and "docker incompatible" (e.g. bare metal). Please look at the inventory file (hosts).

This playbook has three roles:
- bench - run benchmark on all hosts according to the command file (`roles/bench/vars/main.yml`), and collect result profiles to localhost
- parse - parse all result profiles and merge them into a CSV file by using each `parse.sh` script in the benchmark folder.
- show - get ready to visualize all benchmark results by launching a scipy-notebook docker container

#### usage
Check all the hosts in the inventory file (hosts), then
```bash
ansible-playbook bench.yml
```
