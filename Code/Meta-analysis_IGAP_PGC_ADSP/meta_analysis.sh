#!/bin/bash
#PBS -N meta_analysis
#PBS -e ${HOME}/Alzheimers_metaanalysis
#PBS -o ${HOME}/hell_logs/Alzheimers_metaanalysis
#PBS -l walltime=50:00:00,nodes=1:ppn=4
#PBS -S /bin/bash

# ## Meta-analysis script using PLINK2. 
# ## Roxanna Korologou-Linden
#------------------------------------------------------------------------------------

MYDIR="${HOME}/Alzheimers_datasets"

ex="${HOME}/Alzheimers_datasets/plink"
# the ALSPAC data directory


# make sure you are in the correct directory
cd $MYDIR


$ex --meta-analysis $MYDIR/ADSP_for_plink.txt $MYDIR/PGC_for_plink.txt $MYDIR/IGAP_for_plink.txt + qt report-all

 