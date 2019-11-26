library(data.table)
setwd("/pathname/Alzheimers_datasets/")
metaanalysis <- fread("/pathname/Alzheimers_datasets/plink.meta")

metaanalysis$SE <- abs(plink$BETA/qnorm(plink$P/2))

metaanalysis$`P(R)` <- NULL
metaanalysis$`BETA(R)`<- NULL
metaanalysis$Q<- NULL
metaanalysis$I <- NULL

## PROBLEMATIC SNPs identified
metaanalysis_problematic_snps <- fread("/pathname/Alzheimers_datasets/plink.prob", he=F)
colnames(metaanalysis_problematic_snps)[2] <- "snp"
write.table(metaanalysis_problematic_snps$snp, "metaanalysis_problematic_snps.txt", row.names=F)

write.table(metaanalysis,"metaanalysis.txt", quote=F, row.names=F)
