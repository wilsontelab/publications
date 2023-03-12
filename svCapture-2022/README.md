## svCapture-2022

Folder svCapture-2022 carries job configuration scripts, log file outputs,
and other data resources related to 
[Wilson et al. 2022](https://www.biorxiv.org/content/10.1101/2022.07.07.497948v1),
which describes the implementation and validation of error minimization 
approaches for structural variant (SV) detection in short-read capture libraries.

Sufficient materials are provided to reproduce analysis of the reported data sets.

Depending on your needs, you may find it easier to use the simpler 
[svCapture demo](https://wilsontelab.github.io/svx-mdi-tools/docs/svCapture/toy-example.html).

## Source publication

For more information, please see and cite:

- <https://www.biorxiv.org/content/10.1101/2022.07.07.497948v1>

## Associated sequencing data sets

The sequencing data sets in the above publication are available via SRA and summarized in the table below:
- <https://www.ncbi.nlm.nih.gov/sra?LinkName=gap_sra_all&from_uid=2297510>

These are restricted human samples for which you 
will need download permissions from dbGaP (click on an SRR file in SRA to learn more).

For reproduction purposes, please download the SRR files into the **sra** directory after cloning this repository.
Each .sra file should be in its own, similarly named folder, e.g., 'sra/SRR22419712/SRR22419712.sra'.

|SRA_Run_ID  |Description                                                                  |
|------------|-----------------------------------------------------------------------------|
|SRR22419712 |DupSeq svCapture of the human HF1 cell line                                  |
|SRR22419713 |DupSeq svCapture of a mixture of clones of the human HF1 cell line, mix B    |
|SRR22419714 |DupSeq svCapture of a mixture of clones of the human HF1 cell line, mix C    |
|SRR22419715 |DupSeq svCapture of a mixture of clones of the human HF1 cell line, mix D    |
|SRR22419716 |DupSeq svCapture of a mixture of clones of the human HF1 cell line, mix E    |
|SRR22419717 |DupSeq svCapture of the human HF1 cell line, untreated, replicate 1          |
|SRR22419718 |DupSeq svCapture of the human HF1 cell line, untreated, replicate 2          |
|SRR22419719 |DupSeq svCapture of the human HF1 cell line, 0.2 uM aphidicolin, replicate 1 |
|SRR22419720 |DupSeq svCapture of the human HF1 cell line, 0.6 uM aphidicolin, replicate 1 |
|SRR22419721 |DupSeq svCapture of the human HF1 cell line, 0.6 uM aphidicolin, replicate 2 |
|SRR22419722 |Nextera svCapture of the human HF1 cell line, untreated, replicate 1         |
|SRR22419723 |Nextera svCapture of the human HF1 cell line, 0.6 uM aphidicolin, replicate 1|
|SRR22419724 |Nextera svCapture of a mixture of clones of the human HF1 cell line, mix B   |

## Required code suite and genome files

The svCapture pipeline and app are implemented in this Michigan Data Interface tool suite:
- repository: <https://github.com/wilsontelab/svx-mdi-tools>
- documentation: <https://wilsontelab.github.io/svx-mdi-tools>

To reproduce our data analysis, please follow the documentation instructions to install the required code and hg38 genome. Job scripts below
assume you have installed hg38 into the **genomes** folder.

## Resource files

The **resources** folder has additional required supporting data files:

| File        | Description |
| ----------- | ----------- |
| umis-96-v1.txt      | DupSeq UMI file used by the 'align' action       |
| HF1_capture_targets.hg38.bed   | the three 250kb regions target for capture        |
| (un)blinded_cnvs.hg38.bed   | the known HF1 CNVs in mixed_clone samples        |

The easiest way to use these files is to clone this repository and run its reproduction scripts, as described below.

## Work jobs as we ran them

This section summarizes the job configuration files and output logs as we ran them for the work reported in the paper.

### Job configuration scripts

Folder **our-job-files/job-scripts** has subfolders for Duplex Sequencing (DupSeq)
and tagmentation (Nextera), which each carry YAML-format job
configuration scripts for the following sample sets:

- DupSeq/mixed_clones
- DupSeq/APH_populations
- Nextera/tagmentation (a subset of the same DNA samples used for DupSeq)

This folder and the DupSeq and Nextera folders additionally carry files
named **svCapture.yml** that provide environment-level parameters for 
job configuration.

### Job output logs

Folder **our-job-files/composite-logs** carries terminal files that are the 
results of running:

```
mdi <name>.yml report -j all > <name>.report_all.txt
```

on each job configuration script, that thereby carry all of the primary
pipeline job logs. You can execute the same command (and more) if you 
clone this repository and install the required code.

Information found in the log files includes software versions in use
and various output statistics.

## Reproducing the analysis on your system

Folder **for-reproduction** has job scripts you can use to repeat 
analysis of our data sets on your system.

First, clone this repository and change to the project folder:

```sh
git clone https://github.com/wilsontelab/publications.git
cd publications/svCapture-2022
```

Next, install the svx-mdi-tools suite and hg38 iGenome following the documentation
in the links provided above. 

Commands below assume you:
- created an alias or PATH variable to the `mdi` command utility
- installed the hg38 genome into the **genomes** folder
- downloaded the SRR sequence files into the **sra** folder. 

Please adjust  commands and/or edit the job files
as needed if you chose different installation/download options.

The following commands will execute the 'DupSeq_mixed_clones' analysis.
Minor modifications will similarly execute the 'DupSeq_APH_populations'
and 'tagmentation' analyses. They are split this way because each of the
analysis sets were originally sequenced together. 

```sh
cd for-reproduction/DupSeq

# explore the job script and its options
cat mixed_clones.yml
mdi inspect mixed_clones.yml

# launch the pipeline in the shell like any program
mdi svCapture mixed_clones.yml --dry-run
mdi svCapture mixed_clones.yml

# or, alternatively, submit the pipeline jobs to a server job scheduler
# add '--account XYZ' or other server options as needed
mdi submit --dry-run mixed_clones.yml
mdi submit mixed_clones.yml 
```

If you have Singularity available on your system, you will be prompted
to approve download of the pipeline's container(s). If not, the above
commands will fail until you build your conda environments using:

```sh
# add option '--force' to avoid being prompted multiple times
mdi svCapture conda --create 
```

