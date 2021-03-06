# Benchmark Collections

All benchmarks can be run by `run.sh` script or docker run command as described in each benchmark folder, respectively. The `parse.sh` file is necessary for each benchmark to parse the result benchmark profile to a CSV file in specific format.

#### Conventions
- By running the `run.sh` script or the benchmark image in a container, a result profile should be created as output.
- The `parse.sh` takes two result profiles (base and target) and parse the content to a CSV file with such header:
    ```
    machine,limits,benchmark,base_result,lower_is_better,result
    ```
    
    **machine:** Name of the machine under test.
    
    **limits:** with/without. Whether resource restriction applied when running the benchmark.
    
    **benchmark:** ID of a benchmark, e.g. `sysbench_fileio_seqrewr_event-fq`.
    
    **lower_is_better:** True/False.
