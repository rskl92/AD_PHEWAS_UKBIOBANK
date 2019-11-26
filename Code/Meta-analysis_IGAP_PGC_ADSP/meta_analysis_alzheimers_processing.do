clear
*1.Create files to use as input for PLINK metaanalysis
import delimited "${HOME}\Alzheimers_datasets\ADSP_sumstats_reformatted_MRBase.csv"

preserve
rename a1 A1
rename a2 A2
rename maf MAF
rename se SE
rename p P
rename snp SNP
rename beta_lnor BETA
rename chr CHR
rename bp BP
export delimited SNP CHR BP A1 A2 MAF BETA SE P  using "${HOME}\Alzheimers_datasets\ADSP_for_plink.txt", delimiter(tab) replace


restore
rename a1 A1_adsp
rename a2 A2_adsp
rename maf maf_adsp
rename beta_lnor beta_adsp
rename se se_adsp
drop _merge
save "${HOME}\Alzheimers_datasets\ADSP.dta", replace

clear
import delimited "${HOME}\Alzheimers_datasets\PGC_sumstats_reformatted_MRBase.csv"
preserve
rename a1 a1_pgc
rename a2 a2_pgc
rename beta_lnor beta_pgc
rename frq_u_14741 eaf_pgc
rename p p_pgc
rename se se_pgc
keep snp a1_pgc a2_pgc beta_pgc se_pgc p_pgc frq_a_2736 eaf_pgc
save "${HOME}\Alzheimers_datasets\PGC.dta", replace

restore
rename snp SNP
rename chr CHR
rename bp BP
rename a1 A1
rename a2 A2
rename beta_lnor BETA
rename p P
rename se SE
*Generate file to use in plink
export delimited SNP CHR BP A1 A2 BETA SE P using "${HOME}\Alzheimers_datasets\PGC_for_plink.txt", delimiter(tab) replace 



clear
import delimited "${HOME}/Alzheimers_datasets\IGAP_stage_1.txt"
preserve
rename effect_allele A1
rename markername SNP
rename non_effect_allele A2
rename beta BETA
rename pvalue P
rename se SE
rename chromosome CHR
rename position BP 
*Generate file to use in plink
export delimited SNP CHR BP A1 A2 BETA SE P using "${HOME}\Alzheimers_datasets\IGAP_for_plink.txt", delimiter(tab) replace


restore

rename effect_allele a1_igap
rename markername snp
rename non_effect_allele a2_igap
rename beta beta_igap
rename pvalue p_igap
rename se se_igap
keep snp chromosome position a1_igap a2_igap beta_igap se_igap p_igap
save "${HOME}\Alzheimers_datasets\IGAP.dta", replace

*2. After formatting the plink.meta file in R using the fread command, import the processed file into R in order to ensure alleles are alligned
*Import R-formatted plink.meta file // double check alleles and frequencies are alligned
*Note SE is NA where p is 1


*Merging all datasets together to extract EAF info (IGAP not needed as it does not provide any EAF info)
*Merge problematic SNPs and remove (i.e. those SNPs with the same RSID but different chromosome and position)
*Import SNPs that were problematic into STATA
 clear
import delimited "${HOME}\Alzheimers_datasets\metaanalysis_without_frequencies_n.txt", delimiter(whitespace) 
save "${HOME}\Alzheimers_datasets\metaanalysis_alzheimers_three_sample.dta", replace
clear
import delimited "${HOME}\metaanalysis_problematic_snps.txt", varnames(1) clear 
rename x snp
save "${HOME}\Alzheimers_datasets\metaanalysis_problematic_SNPs.dta", replace

clear
use "${HOME}\Alzheimers_datasets\metaanalysis_alzheimers_three_sample.dta"
merge 1:1 snp using "${HOME}\alzheimers_datasets\metaanalysis_problematic_SNPs.dta"
drop if _merge==3 //*drop if problematic SNPs are in metaanalysis
drop _m


*//merge with PGC and ADSP to obtain EAF and switch alleles
merge 1:1 snp using "${HOME}\Alzheimers_datasets\PGC.dta" 
drop if _merge==2 //*drop if only in using dataset (problematic snps)
drop _merge
merge 1:1 snp using "${HOME}\lzheimers_datasets\adsp.dta"
drop if _merge==2 //*drop if only in using dataset
drop _merge


gen A1=a1_pgc if !missing(eaf_pgc)
gen A2=a2_pgc if !missing(eaf_pgc)
replace A1=A1_adsp if missing(eaf_pgc) & !missing(maf_adsp)
replace A2=A2_adsp if missing(eaf_pgc) & !missing(maf_adsp)
replace A1=a1 if missing(eaf_pgc) & missing(maf_adsp)
replace A2=a2 if missing(eaf_pgc) & missing(maf_adsp)
gen beta_f=beta if a1==a1_pgc & !missing(eaf_pgc)
replace beta_f=beta if missing(eaf_pgc) & missing(maf_adsp) //*IGAP doesn't have EAF
replace beta_f=-(beta) if a1==a2_pgc & !missing(eaf_pgc)
replace beta_f=beta if a1==A1_adsp & missing(eaf_pgc)
gen eaf_f=eaf_pgc if !missing(eaf_pgc)
replace eaf_f=maf_adsp if missing(eaf_pgc)

rename beta_f BETA
rename eaf_f EAF
rename se SE
rename chr CHR
rename bp BP
rename p P


export delimited CHR BP snp A1 A2 BETA SE P EAF using "${HOME}\Alzheimers_datasets\alzheimers_metaanalysis_ukb_igap_pgctxt", delimiter(tab) replace


