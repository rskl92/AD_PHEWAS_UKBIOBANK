module load languages/R-3.3.1-ATLAS
R
##set directory 
setwd("/newhome/rk17685/UKB_AD_PHEWAS/ukb_ad_phewas/Data/SNPs_AD_in_UKB")
linker<-read.csv("/newhome/rk17685/UKB_AD_PHEWAS/ukb_ad_phewas/Data/Phenotype_UKB/data.7341.csv")
grs_apoe = data.frame()
temp_apoe = read.delim("UKBB_AD_APOE_PRS_IGpgcADSP_HRCpanel.sscore",sep="	")
temp_apoe <- temp_apoe[,c("IID","SCORE1_AVG")]
colnames(temp_apoe) <- c("app8786","PRS")
grs_apoe= merge(temp_apoe,linker,by="app8786")
grs_apoe= grs_apoe[,c("app16729","PRS")]
colnames(grs_apoe) <- c("eid","PRS")

grs_noapoe = data.frame()
temp_noapoe = read.delim("UKBB_AD_NOAPOE_PRS_IGpgcADSP_HRCpanel.sscore",sep="	")
temp_noapoe <- temp_noapoe[,c("IID","SCORE1_AVG")]
colnames(temp_noapoe) <- c("app8786","PRS")
grs_noapoe= merge(temp_noapoe,linker,by="app8786")
grs_noapoe= grs_noapoe[,c("app16729","PRS")]
colnames(grs_noapoe) <- c("eid","PRS")

write.csv(grs_apoe,"UKBB_AD_APOE_PRS_IGpgcADSP_HRCpanel.csv",row.names=FALSE)
write.csv(grs_noapoe,"UKBB_AD_NOAPOE_PRS_IGpgcADSP_HRCpanel.csv",row.names=FALSE)

##read in prs including apoe
prs_apoe <- read.csv("UKBB_AD_APOE_PRS_IGpgcADSP_HRCpanel.csv")

##read in confounder file and extract age and sex
confounder<- read.csv("/panfs/panasas01/sscm/rk17685/PHEWAS_BIOBANK_UPDATED/Data/Phenotypic/data.21753-phesant_header-confounders.csv")

##merge
datamerge <- merge(prs_apoe,confounder,by="eid")
sort1.datamerge <- datamerge[order(datamerge$x21022_0_),]


t1 <- sort1.datamerge[1:111656,]
t1 <- t1[,c("eid","PRS")]


t2 <- sort1.datamerge[111657:223312,]
t2 <- t2[,c("eid","PRS")]


t3 <- sort1.datamerge[223313:334968,]
t3 <- t3[,c("eid","PRS")]



write.csv(t1,"UKB_PRS_T1APOE_IgPGCadsp_HRCpanel.csv",row.names=FALSE)
write.csv(t2,"UKB_PRS_T2APOE_IgPGCadsp_HRCpanel.csv",row.names=FALSE)
write.csv(t3,"UKB_PRS_T3APOE_IgPGCadsp_HRCpanel.csv",row.names=FALSE)




