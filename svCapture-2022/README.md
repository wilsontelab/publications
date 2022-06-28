## svCapture-2022

Folder svCapture-2022 carries the job configuration scripts, log file outputs,
and other data resources related to 
[Wilson et al. 2022](),
which describes the implementation and validation of error minimization 
approaches for structural variant (SV) detection in short-read capture libraries.

## Source publication

For more information, please see:

- [citation pending]()

## Michigan Data Interface svx-mdi-tools suite

### svCapture pipeline

Job scripts were written for, and executed by, the svCapture pipeline
available in the 
[svx-mdi-tools](https://github.com/wilsontelab/svx-mdi-tools)
software suite of the 
[Michigan Data Interface](https://github.com/MiDataInt) (MDI),
which makes use of genomics modules found in suite 
[genomex-mdi-tools](https://github.com/wilsontelab/genomex-mdi-tools).

Please click on the links above to learn how to install
and use the MDI, the svCapture pipeline, and other svx and genomex tools.

### svCapture app

The svCapture pipeline creates output files that are packaged into a zip
file suitable for loading into the associated svCapture R Shiny app, also
found in the 
[svx-mdi-tools](https://github.com/wilsontelab/svx-mdi-tools)
software suite.

## Job configuration scripts

The **job-scripts** folder has subfolders for Duplex Sequencing (DupSeq)
and tagmentation (Nextera), which each carry YAML-format job
configuration scripts for the following sample sets:

- DupSeq/mixed_clones
- DupSeq/APH_populations
- Nextera/tagmentation (a subset of the same DNA samples used for DupSeq)

This folder and the DupSeq and Nextera folders additionally carry files
named **svCapture.yml** that provide environment-level parameters for 
job configuration.

The YAML files can be directly inspected for option values,
or you can install the MDI and svx tools as described above to read them
or adapt them to your needs.

## Job output logs

The **composite-logs** folder carries terminal files that are the 
results of running:

```
mdi <name>.yml report -j all > <name>.report_all.txt
```

on each job configuration script, that thereby carry all of the primary
pipeline job logs. You can execute the same command (and more) if you 
clone this repository and install the MDI and svx tools as described above.

Information found in the log files includes software versions in use
and various output statistics.

## Resource files

The **resources** folder has additional supporting data files:

- **umis-96-v1.txt** = DupSeq UMI file used by the 'align' action
- **HF1_capture_targets.hg38.bed** = the three 250kb regions target for capture
- **(un)blinded_cnvs.hg38.bed** = the known HF1 CNVs in mixed_clone samples
