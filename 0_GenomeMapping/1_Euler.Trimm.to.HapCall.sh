#############################################
### 07 NOV 2019 - Danilo Pereira - Zurich ###
#############################################

# > Running performed on high computing cluster of ETH - Euler

#####################################################################################
# > This script will be used to go from trimming of raw reads to genome vcf files ###
#####################################################################################

# use /cluster/scratch/user as your working directory
# use /cluster/scratch/ddanilo/AdditionalGenomes2019 as your working directory

# Before starting loop do the following:
# 1) make directories:
#mkdir TrimmedReads
#mkdir BAMfiles
#mkdir RefGenome
#mkdir SAMfiles	
#mkdir gVCF_files

# 2) load all necessary software
module load java
module load samtools
module load bowtie2

# for software that is not directly available on the cluster, download software on the cluster in ~/software, then define variables:
#GATK=~/software/gatk-4.0.2.0
#TRIMM=~/software/Trimmomatic-0.36

while read line
	do
		t=24:00
		n=2
		mem=4096
		#echo $line
		linearray=( $line )
		
	    if [[ "${linearray[0]}" == 'danilo' ]]; then # it will check column 0. if ==Danilo, then jump the row to the next.
	       continue
	     fi
		
		givenR1=${linearray[3]}
		givenR2=${linearray[4]}
		Sample=${linearray[5]}
		#Country=${linearray[1]}
		#Region=${linearray[2]}
	
		RawReadsFolder="/cluster/scratch/ddanilo/Danilo_Stago/Analyzed_data/Raw"
		rawR1=$( find $RawReadsFolder -name "*${givenR1}" )
		rawR2=$( find $RawReadsFolder -name "*${givenR2}" )
		#echo $rawR1 $rawR2
		
		trimR1=$Sample.trim.R1.fastq.gz
		trimR2=$Sample.trim.R2.fastq.gz
		unpR1=$Sample.unp.R1.fastq.gz
		unpR2=$Sample.unp.R2.fastq.gz
		REF="/cluster/scratch/ddanilo/AdditionalGenomes2019/RefGenome/SN2000"
		TrimmedReads="/cluster/scratch/ddanilo/AdditionalGenomes2019/TrimmedReads"
		SAMfiles="/cluster/scratch/ddanilo/AdditionalGenomes2019/SAMfiles"
		BAMfiles="/cluster/scratch/ddanilo/AdditionalGenomes2019/BAMfiles"
		gVCF_files="/cluster/scratch/ddanilo/AdditionalGenomes2019/gVCF_files"
		
		echo "java -jar $TRIMM/trimmomatic-0.36.jar PE -threads $n $rawR1 $rawR2 $TrimmedReads/$trimR1 $TrimmedReads/$unpR1 $TrimmedReads/$trimR2 $TrimmedReads/$unpR2 ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:4:15 MINLEN:50" > $Sample.sh
	
		echo "bowtie2 -p $n --very-sensitive-local --rg-id $Sample --rg SM:$Sample -x $REF -1 $TrimmedReads/$trimR1 -2 $TrimmedReads/$trimR2 -S $SAMfiles/$Sample.sam" >> $Sample.sh
	
		echo "samtools view -bS $SAMfiles/$Sample.sam | samtools sort - $BAMfiles/$Sample" >> $Sample.sh
		
		echo "samtools index $BAMfiles/$Sample.bam" >> $Sample.sh
	
		echo "$GATK/gatk --java-options \"-Xmx4G\" HaplotypeCaller -R $REF.fasta -ploidy 1 --emit-ref-confidence GVCF -I $BAMfiles/$Sample.bam -O $gVCF_files/$Sample.g.vcf" >> $Sample.sh
	
	#sh $Sample.sh
	bsub -W $t -n $n -R "rusage[mem=$mem]" < $Sample.sh
		
	done < global.pnodorum.txt