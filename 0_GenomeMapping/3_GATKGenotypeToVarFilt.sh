#############################################
### 29 NOV 2019 - Danilo Pereira - Zurich ###
#############################################

# > Running performed on high computing cluster of ETH - Euler

#################################################################################
# > This script will take the combined vcf file and perform filtering of SNPs ###
#################################################################################

##############################
### >>> P nodorum only <<< ###
##############################

# run GATK4 GenotypeGVCFs on each file individually
n=1
REF="/cluster/scratch/ddanilo/AdditionalGenomes2019/RefGenome/SN2000"
BASE="/cluster/scratch/ddanilo/AdditionalGenomes2019"

## run GenotypeGVCF
# --allow-old-rms-mapping-quality-annotation-data to allow usage of g.vcf files made with gatk versions older than 4
echo "$GATK/gatk --java-options '-XX:+UseSerialGC' GenotypeGVCFs --allow-old-rms-mapping-quality-annotation-data \
	   -R $REF.fasta \
	   --verbosity ERROR \
	   -V $BASE/gVCF_files_unique/pnod366.combined.g.vcf \
	   --max-alternate-alleles 2 \
	   -O $BASE/gVCF_genotyped/pnod366.genotypedGVC.vcf" > $BASE/gVCF_genotyped/6_GATK4_run.sh

bsub -W 24:00 -n 1 -R "rusage[mem=16000]" -J pnod366genotype -w "done(pnod366combine)" < 6_GATK4_run.sh



# SelectVariants
echo "$GATK/gatk SelectVariants \
	    -R $REF.fasta \
	    -V $BASE/gVCF_genotyped/pnod366.genotypedGVC.vcf \
	    --select-type-to-include SNP \
	    -O $BASE/gVCF_genotyped/pnod366.genotyped.SNPonly.vcf" > $BASE/gVCF_genotyped/7_GATK4_run.sh

bsub -W 24:00 -n 1 -R "rusage[mem=16000]" -J pnod366selectv -w "done(pnod366genotype)" < 7_GATK4_run.sh


	   
### IMPORTANT set the minimum genotyping rate
AN=100 # minimum number of isolates that are genotyped at a locus
QUAL=1000.0
QD=5.0
MQ=20.0
ReadPosRankSum_lower=-2.0
ReadPosRankSum_upper=2.0
MQRankSum_lower=-2.0
MQRankSum_upper=2.0
BaseQRankSum_lower=-2.0
BaseQRankSum_upper=2.0

echo "$GATK/gatk --java-options '-XX:+UseSerialGC' VariantFiltration -R $REF.fasta \
	   	-V $BASE/gVCF_genotyped/pnod366.genotyped.SNPonly.vcf \
	   	--filter 'AN < $AN' --filter-name 'nSamples' \
	   	--filter 'QD < $QD' --filter-name 'QDFilter' \
	   	--filter 'QUAL < $QUAL' --filter-name 'QualFilter' \
	   	--filter 'MQ < $MQ' --filter-name 'MQ' \
	   	--filter 'ReadPosRankSum < $ReadPosRankSum_lower' --filter-name 'ReadPosRankSum' \
	   	--filter 'ReadPosRankSum > $ReadPosRankSum_upper' --filter-name 'ReadPosRankSum' \
	   	--filter 'MQRankSum < $MQRankSum_lower' --filter-name 'MQRankSum' \
	   	--filter 'MQRankSum > $MQRankSum_upper' --filter-name 'MQRankSum' \
	   	--filter 'BaseQRankSum < $BaseQRankSum_lower' --filter-name 'BaseQRankSum' \
	   	--filter 'BaseQRankSum > $BaseQRankSum_upper' --filter-name 'BaseQRankSum' \
	   	-O $BASE/gVCF_genotyped/pnod366.genotyped.SNPonly.AN=$AN.vcf" > $BASE/gVCF_genotyped/8_GATK4_run.sh

bsub -W 12:00 -n 1 -R "rusage[mem=16000]" -J pnod366SNP -w "done(pnod366selectv)" < 8_GATK4_run.sh

##################################
### >>> Non P nodorum only <<< ###
##################################

# run GATK4 GenotypeGVCFs on each file individually
n=1
REF="/cluster/scratch/ddanilo/AdditionalGenomes2019/RefGenome/SN2000"
BASE="/cluster/scratch/ddanilo/AdditionalGenomes2019"

## run GenotypeGVCF
# --allow-old-rms-mapping-quality-annotation-data to allow usage of g.vcf files made with gatk versions older than 4
echo "$GATK/gatk --java-options '-XX:+UseSerialGC' GenotypeGVCFs --allow-old-rms-mapping-quality-annotation-data \
	   -R $REF.fasta \
	   --verbosity ERROR \
	   -V $BASE/gVCF_non_pnodorum/pnod21.combined.g.vcf \
	   --max-alternate-alleles 2 \
	   -O $BASE/gVCF_genotyped/pnod21.genotypedGVC.vcf" > $BASE/gVCF_genotyped/6_GATK4_run.sh

bsub -W 24:00 -n 1 -R "rusage[mem=16000]" -J pnod21genotype -w "done(pnod21combine)" < 6_GATK4_run.sh



# SelectVariants
echo "$GATK/gatk SelectVariants \
	    -R $REF.fasta \
	    -V $BASE/gVCF_genotyped/pnod21.genotypedGVC.vcf \
	    --select-type-to-include SNP \
	    -O $BASE/gVCF_genotyped/pnod21.genotyped.SNPonly.vcf" > $BASE/gVCF_genotyped/7_GATK4_run.sh

bsub -W 24:00 -n 1 -R "rusage[mem=16000]" -J pnod21selectv -w "done(pnod21genotype)" < 7_GATK4_run.sh


	   
### IMPORTANT set the minimum genotyping rate
AN=4 # minimum number of isolates that are genotyped at a locus
QUAL=1000.0
QD=5.0
MQ=20.0
ReadPosRankSum_lower=-2.0
ReadPosRankSum_upper=2.0
MQRankSum_lower=-2.0
MQRankSum_upper=2.0
BaseQRankSum_lower=-2.0
BaseQRankSum_upper=2.0

echo "$GATK/gatk --java-options '-XX:+UseSerialGC' VariantFiltration -R $REF.fasta \
	   	-V $BASE/gVCF_genotyped/pnod21.genotyped.SNPonly.vcf \
	   	--filter 'AN < $AN' --filter-name 'nSamples' \
	   	--filter 'QD < $QD' --filter-name 'QDFilter' \
	   	--filter 'QUAL < $QUAL' --filter-name 'QualFilter' \
	   	--filter 'MQ < $MQ' --filter-name 'MQ' \
	   	--filter 'ReadPosRankSum < $ReadPosRankSum_lower' --filter-name 'ReadPosRankSum' \
	   	--filter 'ReadPosRankSum > $ReadPosRankSum_upper' --filter-name 'ReadPosRankSum' \
	   	--filter 'MQRankSum < $MQRankSum_lower' --filter-name 'MQRankSum' \
	   	--filter 'MQRankSum > $MQRankSum_upper' --filter-name 'MQRankSum' \
	   	--filter 'BaseQRankSum < $BaseQRankSum_lower' --filter-name 'BaseQRankSum' \
	   	--filter 'BaseQRankSum > $BaseQRankSum_upper' --filter-name 'BaseQRankSum' \
	   	-O $BASE/gVCF_genotyped/pnod21.genotyped.SNPonly.AN=$AN.vcf" > $BASE/gVCF_genotyped/8_GATK4_run.sh

bsub -W 12:00 -n 1 -R "rusage[mem=16000]" -J pnod21SNP -w "done(pnod21selectv)" < 8_GATK4_run.sh