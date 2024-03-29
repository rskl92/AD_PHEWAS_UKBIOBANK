#!/bin/bash
#PBS -l walltime=300:00:00,nodes=1:ppn=1
#PBS -o out-pIDX-200.file


module add languages/R-3.3.1-ATLAS

date

export Results="${HOME}/ukb_ad_phewas/Results"
PHESANT="${HOME}/PHESANT-master"
codeDir="${PHESANT}/WAS/"
varListDir="${PHESANT}/variable-info/"

outcomeFile="${HOME}/Phenotype_UKB/data.21753-phesant_header.csv"
expFile="${PROJECT_DATA}/SNPs_AD_in_UKB/UKB_PRS_T2APOE_IgPGCadsp_HRCpanel.csv"
varListFile="${varListDir}outcome-info.tsv"
dcFile="${varListDir}data-coding-ordinal-info.txt"

#start and end of index of phenotypes
pIdx=IDX
np=200


# confounders
confFile="${PROJECT_DATA}/UKB_Phenotype/data.21753-phesant_header-confounders.csv"

resDir="${Results}/Tertile2_HRC/"

# run PHESANT
cd $codeDir
Rscript ${codeDir}phenomeScan.r --partIdx=$pIdx --numParts=$np --phenofile=${outcomeFile} --traitofinterestfile=${expFile} --variablelistfile=${varListFile} --datacodingfile=${dcFile} --traitofinterest="PRS" --standardise=TRUE --resDir=${resDir} --userId="eid" --confounderfile=${confFile} --confidenceintervals=TRUE 



