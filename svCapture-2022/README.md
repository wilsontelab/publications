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

**svCapture: efficient and specific detection of very low frequency structural variant junctions by error-minimized capture sequencing.**<br>
Thomas E Wilson, Samreen Ahmed, Jake Higgins, Jesse J Salk, Thomas W Glover.<br>
[_NAR Genomics and Bioinformatics_](https://doi.org/10.1093/nargab/lqad042), 
5:lqad042 (2023).<br>
[PMID: 37181851](https://pubmed.ncbi.nlm.nih.gov/37181851/), 
[PMCID: PMC10167630](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10167630/)

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

### Alternative sequence files to use for testing

You can also make small modifications to the reproduction job scripts
to use any other paired-end WGS data as input. One unrestricted example we have used is:

- <https://www.ncbi.nlm.nih.gov/sra/?term=SRR21384118>

Most inputs, like the one linked above, will not have been subjected
to appropriate target capture but they can still be analyzed, which will
reveal the failure of targeting to you.

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

Please adjust commands and/or edit the job files
as needed if you chose different installation/download options.

The following commands will execute the 'DupSeq_APH_populations' analysis.
Minor modifications will similarly execute the 'DupSeq_mixed_clones'
and 'tagmentation' analyses. They are split this way because each of the
analysis sets were originally sequenced together. 

```sh
cd for-reproduction/DupSeq

# explore the job script and its options
cat APH_populations.yml
mdi inspect APH_populations.yml

# launch the pipeline in the shell like any program
mdi svCapture APH_populations.yml --dry-run
mdi svCapture APH_populations.yml

# or, alternatively, submit the pipeline jobs to a server job scheduler
# add '--account XYZ' or other server options as needed
mdi submit --dry-run APH_populations.yml
mdi submit APH_populations.yml 
```

If you have Singularity available on your system, you will be prompted
to approve download of the pipeline's container(s). If not, the above
commands will fail until you build your conda environments using:

```sh
# add option '--force' to avoid being prompted multiple times
mdi svCapture conda --create 
```

### Proper job order for the genotype action 

For the genotype actions to run properly, you must
execute the 'DupSeq/APH_populations.yml' script before the 
other data sets, since it generates a SNP file that is used 
by the mixed clone analyses.

## Interactive data analysis in the svCapture app

The job scripts will generate VCF files as well as MDI data packages
that you can load into the svCapture R Shiny app. Follow the documentation
links above to install the app, typically using the 
[MDI Desktop](https://midataint.github.io/mdi-desktop-app/docs/overview). 

The app was used to generate nearly all data figures in the manuscript.
You may use it to interactively explore the data with a variety of
filters and sample combinations, as we did.

Use the tabs at the left to work through the  analysis steps.
The basic actions for most steps are:
- load the required data package(s) into the running app, ending with 'mdi.package.zip'
- assign samples into Sample Sets using `Assign Samples`
- use `Sample Set` and `Select Samples` to choose the samples to plot
- use the gear icon at the top to set SV filtering options

### Sample Sets

The various plots can be directed to load data from just one sample
or many samples together. Use `Assign Samples` to construct
Sample Sets containing samples you wish to co-analyze.

### Settings

The methods paper explored a large variety of different SV filters
to demonstrate their effects. Please see the paper for details.

The `Fragile_Site` preset (under the gear/cog icon) 
sets the filters we typically use for filtering to high confidence
single-molecule deletions in common fragile sites:
- `Min Map Quality` = 20
- `Max Samples With SV` = 1
- `Max Source Molecules` = 1
- `Min Read Count` = 3
