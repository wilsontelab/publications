#!/bin/bash

# Sun Grid Engine directives
#$ -N  svCapture_collate
#$ -wd /nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/.mixed_clones.yml.data/log/slurm
#$ -pe smp 8
#$ -l  vf=4G
#$ -j  y
#$ -o  /nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/.mixed_clones.yml.data/log/slurm
#$ -V 
#$ -t 1-5 
#$ -hold_jid 36975580

# Torque PBS directives
#PBS -N  svCapture_collate
#PBS -d  /nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/.mixed_clones.yml.data/log/slurm
#PBS -l  mem=4gb 
#PBS -j  oe
#PBS -o  /nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/.mixed_clones.yml.data/log/slurm
#PBS -V 
#PBS -t 1-5 
#PBS -W depend=afterok:36975580

# Slurm directives
#SBATCH --job-name=svCapture_collate
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --partition=standard
#SBATCH --output=/nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/.mixed_clones.yml.data/log/slurm/%x.o%A-%a
#SBATCH --account=wilsonte0
#SBATCH --mail-user=nobody\@nowhere.edu
#SBATCH --mail-type=NONE
#SBATCH --export=ALL 
#SBATCH --array=1-5 
#SBATCH --dependency=afterok:36975580

# initialize job and task
source /nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/mdi/frameworks/definitive/mdi-pipelines-framework/job_manager/lib/utilities.sh
checkPredecessors # only continue if dependencies did not time out
getTaskID # determine if this is a specific task of an array job

# pre-execution feedback
echo
echo "---"
echo "job-manager:"
echo "    host: $HOSTNAME"
echo "    started: "`date +'%a %D %R'`

# make array tasks wait different times before starting to minimize lock collisions
if [ "$TASK_NUMBER" != "" ]; then sleep $((TASK_NUMBER * 3)); fi
export GIT_LOCK_WAIT_SECONDS=600

# cascade call to pipeline launcher
TIME_FORMAT="---
job-manager:
    exit_status: %x
    walltime: %E
    seconds: %e
    maxvmem: %MK
    swaps: %W"
/usr/bin/time -f "
$TIME_FORMAT" \
/nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/mdi/mdi \
 \
svx-mdi-tools/svCapture \
collate \
/nfs/turbo/path-wilsonte-turbo/mdi/wilsontelab/greatlakes/data-scripts/wilsontelab/publications/svCapture-2022/job-scripts/DupSeq/mixed_clones.yml $TASK_ID
EXIT_STATUS=$?

# post-execution feedback
echo "---"
echo "job-manager:"
echo "    ended: "`date +'%a %D %R'`
echo "..."

[ "$EXIT_STATUS" -gt 0 ] && EXIT_STATUS=100
exit $EXIT_STATUS
