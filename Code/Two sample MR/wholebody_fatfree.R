
## This calls the packages you just installed so that you can use them ##
library(devtools)
library(TwoSampleMR)
library(MRInstruments)
library(xlsx)
library(psych)
library(ggplot2)
library(plyr)

# get all the available outcomes from MR-BASE
ao <- available_outcomes(access_token=NULL)


#Setting your working directory where everything will be called from and also saved
rm(list=ls())

setwd("pathname/Physical_measures/wholebody_fatfree")
GWS_23101 <- read.csv("GWS_23101.csv")
GWS_23101_ex_apoe <- GWS_23101[!(GWS_23101$CHR==19 &  GWS_23101$POS>=44400000 & GWS_23101$POS<=46500000),] ##REMOVE APOE SNPS
names(GWS_23101_ex_apoe)[1] <- "SNP"



GWS_whole_body_fat_free_S1 <- GWS_23101_ex_apoe[1:54536,] 
GWS_whole_body_fat_free_S2 <- GWS_23101_ex_apoe[54537:109071,] 



exposure_S1<- clump_data(GWS_whole_body_fat_free_S1)
exposure_S2<- clump_data(GWS_whole_body_fat_free_S2)

exposure_total <- rbind(exposure_S1, exposure_S2)

exposure<- clump_data(exposure_total)

write.csv(exposure, "GWS_whole_body_fat_free_clumped_ex_apoe.csv", row.names=FALSE)



##read in exposure
exposure <- read_exposure_data("GWS_whole_body_fat_free_clumped_ex_apoe.csv", sep =",", snp_col = "SNP", beta_col = "BETA", se_col = "SE", eaf_col = "EAF", effect_allele_col = "A1", other_allele_col = "A2", pval_col = "P")

#naming exposure 
exposure$exposure<- "whole body fat-free mass mass"

##read in exposure
outcome_dat <- read_outcome_data("pathname/Alzheimers_datasets/alzheimers_metaanalysis.txt",exposure$SNP, sep="\t",snp_col="snp", beta_col = "BETA",se_col="SE", eaf_col="EAF", effect_allele_col = "A1", other_allele_col = "A2")

##input sample size for exposure and outcome
PGC_IGAP<- read.table("twostudy_PGC_IGAP.txt",he=T)
PGC_IGAP$samplesize.outcome=17477+54162
PGC_IGAP$ncontrol.outcome=14471+37154
PGC_IGAP$ncase.outcome=2736+17008
PGC_adsp <- read.table("twostudy_PGC_ADSP.txt",he=T)
PGC_adsp$samplesize.outcome=14471+7508
PGC_adsp$ncase.outcome=2736+4343
PGC_adsp$ncontrol.outcome=14471+3165
PGC_sample <- read.table("onestudy_PGC.txt",he=T)
PGC_sample$samplesize.outcome=17477
PGC_sample$ncase.outcome=2736
PGC_sample$ncontrol.outcome=14471
IGAP <- read.table("onestudy_IGAP.txt",he=T)
IGAP$samplesize.outcome=54162
IGAP$ncontrol.outcome=37154
IGAP$ncase.outcome=17008
threestudies <- read.table("threestudies_pgc_igap_adsp.txt",he=T)
threestudies$samplesize.outcome <- 17477+7508+54162
threestudies$ncontrol.outcome <- 14471+37154+3165
threestudies$ncase.outcome <- 2736+17008+4343
combined_dataset_sample <- rbind(PGC_IGAP,PGC_adsp,IGAP,PGC_sample,threestudies)
outcome_dat <- merge(outcome_dat,combined_dataset_sample,by.x="SNP",by.y="SNP",all.x=T)
exposure$samplesize.exposure = 454850

##snp rs138799511 has 2066 cases and 7637 controls

#seeing how many rows are int he datset
head(exposure)
dim(exposure)

#harmonising exposure and outcome datasets (making sure alleles aligned, making sure no pallindromic SNPs etc)
dat <- harmonise_data(exposure, outcome_dat, action=2) 

##save snps
whole_body_fatfree<- subset(dat,select="SNP")
write.table(whole_body_fatfree,"whole_body_fatfree_dat.txt", row.names = FALSE, quote=FALSE)

#steiger
dat2 <- dat[dat$mr_keep==TRUE,]
dat2 <- dat[!is.na(dat$eaf.outcome),]
dat2$units.exposure <- "SD"
dat2$units.outcome <- "log odds"
dat2$prevalence.outcome=0.07

out <- steiger_filtering(dat2)
write.csv(out[,c("SNP","rsq.exposure","rsq.outcome","steiger_dir","steiger_pval")], file="pathname/Physical_measures/wholebody_fatfree/wholebody_fatfree_steiger.csv", row.names=FALSE)

true <-  out[out$steiger_dir==TRUE,]

true_mr <- mr(true)

write.csv(true_mr,"true_mr_wholebody_fatfree.csv")
#Running the MR
mr_results <- mr(dat)

#displayng MR results 
mr_results

#Putting MR results into a HTML report
mr_report(dat, output_path = "whole body fat-free mass mass on AD.txt", author="Analyst", study = paste("whole body fat-free mass mass on AD","-Alzheimer's disease",sep=""))
results<-cbind.data.frame(mr_results$outcome,mr_results$nsnp,mr_results$method,mr_results$b,mr_results$se,mr_results$pval)
######################################################################################
# Regression dilution I2 GX test and SIMEX code
######################################################################################
# I-squared function
Isq <- function(y,s){
  k          = length(y)
  w          = 1/s^2; sum.w  = sum(w)
  mu.hat     = sum(y*w)/sum.w  
  Q          = sum(w*(y-mu.hat)^2)
  Isq        = (Q - (k-1))/Q
  Isq        = max(0,Isq)
  return(Isq)
}

#calculate Isq (weighted and unweighted)
I2<-c()

dat <- harmonise_data(exposure, outcome_dat) 
str(dat)


##deleting palindromes and removes for I2 STAT

dat <- subset(dat, subset=!(mr_keep=="FALSE"))

#Rename required columns
dat $BetaXG<-dat $beta.exposure
dat $seBetaXG<-dat $se.exposure
BetaXG   = dat $BetaXG
seBetaXG = dat $seBetaXG 
seBetaYG<-dat $se.outcome

BXG             = abs(BetaXG)         # gene--exposure estimates are positive  

# Calculate F statistics
# and I-squared statistics
# to measure Instrument 
# strength for MR-Egger

F   = BXG^2/seBetaXG^2
mF  = mean(F)
Isq_unweighted <- Isq(BXG,seBetaXG) #unweighted
Isq_weighted <- Isq((BXG/seBetaYG),(seBetaXG/seBetaYG)) #weighted

#Save results
output<-cbind(F, mF, Isq_unweighted, Isq_weighted)
I2<-rbind(I2, output)
colnames(I2) <- c("Exposure", "mF", "Isq_unweighted", "Isq_weighted")
write.csv(I2, file="regression_dilution_isq_weighted.csv", row.names = FALSE)


res <- mr(dat, method_list=c("mr_egger_regression", "mr_ivw"))
dat$exposure <- "whole body fat-free mass"
dat$outcome <- "Alzheimer's disease"
p1 <- mr_scatter_plot(res, dat)
p1[[1]]
dev.off()

#################################################################################
# Simex correction 
#################################################################################
#Run the simex correction for each phenotype
#install.packages("simex")
#load package
library(simex) 

#create empty dataframe to store output
simexegger<-c()


#run simex 
#Rename required columns
dat$BetaXG<-dat$beta.exposure
dat$seBetaXG<-dat$se.exposure
dat$BetaYG<-dat$beta.outcome
dat$seBetaYG<-dat$se.outcome
BetaXG <- dat$BetaXG
BetaYG <- dat$BetaYG
seBetaXG <- dat$seBetaXG
seBetaYG <- dat$seBetaYG


BYG <- BetaYG*sign(BetaXG)# Pre-processing steps to ensure all gene--exposure estimates are positive
BXG <- abs(BetaXG)         

# MR-Egger regression (weighted) 
Fit1 <- lm(BYG ~ BXG,weights=1/seBetaYG^2,x=TRUE,y=TRUE)

# MR-Egger regression (unweighted)
Fit2 <- lm(BYG~BXG,x=TRUE,y=TRUE) 

# Simulation extrapolation 
mod.sim1 <- simex(Fit1,B=1000, measurement.error = seBetaXG, SIMEXvariable="BXG",fitting.method ="quad",asymptotic="FALSE") 
mod.sim2 <- simex(Fit2,B=1000, measurement.error = seBetaXG, SIMEXvariable="BXG",fitting.method ="quad",asymptotic="FALSE") 
mod1<-summary(mod.sim1)
mod2<-summary(mod.sim2)

#display mod1
mod1

#display mod2
mod2