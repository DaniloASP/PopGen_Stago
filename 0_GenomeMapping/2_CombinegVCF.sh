#############################################
### 29 NOV 2019 - Danilo Pereira - Zurich ###
#############################################

# > Running performed on high computing cluster of ETH - Euler

#######################################################################################
# > This script will take individual gvcf files previously generated and merge them ###
#######################################################################################

# CombineGVCFs
REF="/cluster/scratch/ddanilo/AdditionalGenomes2019/RefGenome/SN2000"
BASE="/cluster/scratch/ddanilo/AdditionalGenomes2019/gVCF_files_unique"

# The first step is to make a list of all the g.vcf files generated with the HaplotypeCaller. pnod366 = only P.nodorum
find $BASE -name "*.g.vcf" > $BASE/pnod366.g.vcf.list

# Then, it is possible to join all the files with the tool CombineGVCFs
module load java

echo "$GATK/gatk --java-options '-XX:+UseSerialGC' CombineGVCFs -R $REF.fasta \
-V $BASE/pnod366.g.vcf.list  \
-O pnod366.combined.g.vcf" > run_merge_gVCF

bsub -W 24:00 -n 1 -R "rusage[mem=24000]" -J pnod366combine < run_merge_gVCF

###########

# CombineGVCFs
REF="/cluster/scratch/ddanilo/AdditionalGenomes2019/RefGenome/SN2000"
BASE="/cluster/scratch/ddanilo/AdditionalGenomes2019/gVCF_non_pnodorum"

# The first step is to make a list of all the g.vcf files generated with the HaplotypeCaller. pnod21 = only P.nodorum
find $BASE -name "*.g.vcf" > $BASE/pnod21.g.vcf.list

# Then, it is possible to join all the files with the tool CombineGVCFs
module load java

echo "$GATK/gatk --java-options '-XX:+UseSerialGC' CombineGVCFs -R $REF.fasta \
-V $BASE/pnod21.g.vcf.list  \
-O pnod21.combined.g.vcf" > run_merge_gVCF

bsub -W 12:00 -n 1 -R "rusage[mem=24000]" -J pnod21combine -w "done(pnod366combine)" < run_merge_gVCF