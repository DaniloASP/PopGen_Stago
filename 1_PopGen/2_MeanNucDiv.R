##########################################
### May 2020 - Danilo Pereira - Zurich ###
##########################################

# > The first part will summarise the output from vcftools flag `--site-pi`.
# > The second part will create the nucleotide diveristy plot for each population


#######################################
### Part 1 - Summarise output files ###
#######################################

# loop over files and get nuc diversity per pop
LD.files <- list.files(path = "sites_pi/")
LD.files

directory_files = "sites_pi/"

for (names in LD.files) {
  print(names)
  file_path_pi <- file.path(directory_files, paste(names, sep=""))
  nuc_diversity <- read.table(file=paste0(file_path_pi), stringsAsFactors = FALSE, header = T)
  nuc_diversity_mean <- (mean(na.omit(nuc_diversity$PI)/37459375))
  write.csv(nuc_diversity_mean, file=paste0("mean.",names,".csv"), row.names=F)
}

##########################################
### Part 2 - Plot nucleotide diversity ###
##########################################

# load data

# once nuc div was obtained for all pops. plot
nuc_diversity <- read.table("mean.nucleo.diversity.length.txt", stringsAsFactors = FALSE, header = F)

nuc_diversity<-nuc_diversity[!(nuc_diversity$V1=="NorthDakota2016"),]

# plot
library(ggplot2)
ggplot(nuc_diversity, aes(x=V1, y=V2)) + geom_point(size = 7) + 
  theme(axis.text.x = element_text(angle = 45, size = 5), panel.background = element_rect(fill = 'white', colour = 'white')) +
  scale_x_discrete(limits=c("Population1","Australia","SouthAfrica","Population2","Ohio","NorthCarolina",
                            "Oregon","NewYork","Texas","Arkansas","SwitzerlandA","SwitzerlandB","Population3",
                            "NorthDakota","SouthDakota","Minnesota","Iran","Oklahoma")) + 
  labs(y = "Nucleotide diversity", x = "Populations") + geom_hline(yintercept=c(2e-09,2.5e-09,3e-09,3.5e-09,4e-09,4.5e-09,5e-09)) + 
  scale_y_continuous(breaks = c(2e-09,2.5e-09,3e-09,3.5e-09,4e-09,4.5e-09,5e-09))

ggsave(file = paste0("nuc_diversity_2.pdf"), width = 200, height = 100, units = "mm", device='pdf', useDingbats=F)


### end
