#!/bin/bash 
#PBS -l walltime=40:00:00,nodes=1:ppn=1

cd "/newhome/rk17685/UKB_AD_PHEWAS/ukb_ad_phewas/Code/PheWAS/PRS_APOE_Tertile3_HRC"
 for i in {1..200} 
do
        qsub j-p${i}-200.sh
        sleep 3
 done
