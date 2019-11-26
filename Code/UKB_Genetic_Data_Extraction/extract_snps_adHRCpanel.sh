#!/bin/bash
#PBS -l nodes=1:ppn=16
#PBS -l walltime=00:12:00:00
#PBS -N extract_snps
------------------------------------------------------------------------
module load apps/bgen-1.0.1

cd $PBS_O_WORK_DIR

bgen_pattern="$UKBBDIR_HRC/dosage_bgen/data.chrCHROM.bgen"

bgen_index_pattern="${UKBBDIR_HRC}/dosage_bgen/data.chrCHROM.bgen.bgi"

export DATADIR="${HOME}/UKB_AD_PHEWAS/ukb_ad_phewas/Data/SNPs_AD_in_UKB"
export DISCOVERY_SAMPLE="${HOME}/UKB_AD_PHEWAS/ukb_ad_phewas/Data/Meta-analysis_IGAP_PGC_ADSP"

cd $DATADIR
temp_geno_prefix=temp_genos
for chrom in {1..22}; do
  chrom_padd=$(printf "%0*d\n" 2 $chrom)
  inbgen=${bgen_pattern/CHROM/$chrom_padd}
  inbgenidx=${bgen_index_pattern/CHROM/$chrom_padd}
  bgenix -g $inbgen -i $inbgenidx -incl-rsids $DISCOVERY_SAMPLE/AD_rsids.txt > $DATADIR/$temp_geno_prefix.$chrom_padd.bgen
done
cmd=""
for chrom in {01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22}; do
  cmd="${cmd} ${temp_geno_prefix}.${chrom}.bgen"
done

cat-bgen -g ${cmd} -og $DATADIR/instruments_HRC.bgen
# Remove temp genos
rm $temp_geno_prefix*
