# PHEWAS
This repository accompanies the paper titled "The causes and consequences of Alzheimer’s disease: A Mendelian randomization analysis" 

The PheWAS code is from Louise Millard's scripts https://github.com/MRCIEU/PHESANT-MR-pheWAS-BMI/tree/master/1-BMI-genetic-score
## Environment details
I use the following languages: R.3.3.1, and the PHESANT package v0.15. I used the PLINK v2.0 software for calculation of the polygenic risk score.
## Meta-analysis of GWAS samples for Alzheimer's disease
The meta-analysed effect estimates derived from summary statistics of IGAP, ADSP, and PGC. These will be used to weight the polygenic risk score and for the outcome in the Mendelian 
randomization framework.
## Calculation of the polygenic risk score
The polygenic risk score for Alzheimer's will be used as the exposure in the phenome-scan.
## Phenotype data formatting
This script renames the phenotype to the format in phenotype file column header as required by the PHESANT package. These commands add an 'x' to the beginning of each phenotype 
name, and replace '.' and '-' characters with '_' in the column headers of the phenotype file. 

```bash
datadir="${PROJECT_DATA}/phenotypes/derived/" 
origdir="${UKB_PHENODATA}/_latest/UKBIOBANK_Phenotypes_App_16729/data/" head -n 1 ${origdir}data.21753.csv | sed 's/,"/,"x/g' | sed 's/-/_/g' | sed 's/\./_/g' > 
${datadir}data.21753-phesant_header.csv 
awk '(NR>1) {print $0}' ${origdir}data.21753.csv >> ${datadir}data.21753-phesant_header.csv
```
## Analysis overview
We perform a phenome-wide association study of Alzheimer's disease, using a Alzheimer's genetic score (on the full UKB sample). As most hits were identified in the oldest participants (i.e. third tertile), we followed up those hits using two sample Mendelian Randomization.
We do not present results for low prevalence of trait/disease, if it it is Alzheimer's disease related or where there are no genetic variants.

## Analysis steps
There are 5 main steps: 
1.Meta-analysis of IGAP, PGC, and ADSP

2.Data pre-processing and constructing a polygenic risk score for Alzheimer's disease

3.Generating confounder files to use as covariates in PHEWAS

4.Mendelian Randomization

    
The file `data.21753.csv`is our phenotype file downloaded from UK Biobank.
