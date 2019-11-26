#!/bin/bash 
#PBS -l walltime=40:00:00,nodes=1:ppn=1

cd "${HOME}/ukb_ad_phewas/Code/PheWAS/PRS_NO_APOE_HRC"
 for i in {1..200} 
do
        qsub j-p${i}-200.sh
        sleep 3
 done
