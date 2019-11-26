module load languages/R-3.3.1-ATLAS
R
##set directory 
setwd("/pathname")

##read in prs including apoe
prs_apoe <- read.csv("UKB_PRS_APOE_IgPGCadsp.csv")

##read in confounder file and extract age and sex
confounder<- read.csv("data.21753-phesant_header-confounders.csv")

##merge
datamerge <- merge(prs_apoe,confounder,by="eid")
sort1.datamerge <- datamerge[order(datamerge$x21022_0_),]
sort1.datamerge$PRS_std <- scale(sort1.datamerge$PRS)


t1 <- sort1.datamerge[1:112336,]
t1 <- t1[,c("eid","PRS")]
t1_std <- sort1.datamerge[1:112336,]
t1_std <- t1_std[,c("eid","PRS_std")]
colnames(t1_std) <- c("eid","PRS")

t2 <- sort1.datamerge[112337:224672,]
t2 <- t2[,c("eid","PRS")]
t2_std <- sort1.datamerge[112337:224672,]
t2_std <- t2_std[,c("eid","PRS_std")]
colnames(t2_std) <- c("eid","PRS")

t3 <- sort1.datamerge[224672:337008,]
t3 <- t3[,c("eid","PRS")]
t3_std<- sort1.datamerge[224672:337008,]
t3_std <- t3_std[,c("eid","PRS_std")]
colnames(t3_std) <- c("eid","PRS")


write.csv(t1,"UKB_PRS_T1APOE_IgPGCadsp.csv",row.names=FALSE)
write.csv(t2,"UKB_PRS_T2APOE_IgPGCadsp.csv",row.names=FALSE)
write.csv(t3,"UKB_PRS_T3APOE_IgPGCadsp.csv",row.names=FALSE)

write.csv(t1_std,"UKB_PRS_T1APOEstd_IgPGCadsp.csv",row.names=FALSE)
write.csv(t2_std,"UKB_PRS_T2APOEstd_IgPGCadsp.csv",row.names=FALSE)
write.csv(t3_std,"UKB_PRS_T3APOEstd_IgPGCadsp.csv",row.names=FALSE)




