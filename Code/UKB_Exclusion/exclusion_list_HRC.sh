export Exclusion_Dir="${HOME}/UKB_AD_PHEWAS/ukb_ad_phewas/Data/Exclusion_UKB/HRC"
cat ${Exclusion_Dir}/data.combined_recommended.txt ${Exclusion_Dir}/data.non_white_british.txt > ${Exclusion_Dir}/biobank_exclusion_list.txt
cat ${Exclusion_Dir}/data.minimal_relateds.txt >> ${Exclusion_Dir}/biobank_exclusion_list.txt
cat ${Exclusion_Dir}/data.highly_relateds.txt >> ${Exclusion_Dir}/biobank_exclusion_list.txt
cat ${Exclusion_Dir}/ukb_withdrawal_list.txt >> ${Exclusion_Dir}/biobank_exclusion_list.txt


wc -l  ${Exclusion_Dir}/biobank_exclusion_list.txt


# There are some duplicatesthis line prints out the entries with duplicate lines and counts 

 sort ${Exclusion_Dir}/biobank_exclusion_list.txt | uniq -cd | wc -l

# There are 8675 ids which appear more than once in this list


# To create a file with a single entry per individual

sort ${Exclusion_Dir}/biobank_exclusion_list.txt | uniq > ${Exclusion_Dir}/biobank_exclusion_list_unique.txt
