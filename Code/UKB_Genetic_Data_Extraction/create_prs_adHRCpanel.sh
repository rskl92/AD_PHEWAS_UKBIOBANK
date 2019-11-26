#!/bin/bash
#PBS -N PRS_AD
#PBS -o PRS_AD_output
#PBS -e PRS_AD_error
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=2
#PBS -S /bin/bash
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export SNP_DIR="${HOME}/ukb_ad_phewas/Data/SNPs_AD_in_UKB"
export DISCOVERY_SAMPLE="${HOME}/ukb_ad_phewas/Data/Meta-analysis_IGAP_PGC_ADSP"
export EXCLUSION_DIR="${HOME}/ukb_ad_phewas/Data/Exclusion_UKB/HRC"
cd $SNP_DIR \

module load apps/plink-2.00 \


plink \
--bgen ${SNP_DIR}/instruments_HRC.bgen \
--sample ${UKBBDIR_HRC}/sample-stats/data.chr01.sample \
--score ${DISCOVERY_SAMPLE}/metaanalysis_effects.txt no-mean-imputation list-variants \
--remove ${EXCLUSION_DIR}/total_exclusions.txt \
--out ${SNP_DIR}/UKBB_AD_APOE_PRS_IGpgcADSP_HRCpanel \

