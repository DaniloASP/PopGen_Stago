#############################################
#### March 2020 - Danilo Pereira - Zurich ###
#############################################

# > This script will take the PCA output from plink software and create the result's plot

# load libs
library(dplyr)
library(ggplot2)

# load data
PCA_all_pc <- read.table("../../PhD_stago/Complete/output1.txt", header = T, stringsAsFactors = FALSE)
global_file <- read.table("../../PhD_stago/global.pnodorum.txt", header = TRUE, sep= "|", stringsAsFactors = FALSE)


# correct names between output from ngs_te_manager and global pop file
PCA_all_pc$Taxa <- gsub("-","_", PCA_all_pc$Taxa)

# ad a column from global file that contains the country id per isolate
global_file_populations <- select(global_file, isolate, population_country) # it will reduce the df with original names
i1 <- match(PCA_all_pc$Taxa, global_file_populations$isolate) # will match "pnod*" names from mydata and global_file
PCA_all_pc$population_country <- global_file_populations$population_country[i1] # will replace match "pnod*" acconrdingly with the other column (isolate)

# ad a column from global file that contains the country id per isolate
global_file_populations <- select(global_file, isolate, location3) # it will reduce the df with original names
i1 <- match(PCA_all_pc$Taxa, global_file_populations$isolate) # will match "pnod*" names from mydata and global_file
PCA_all_pc$location3 <- global_file_populations$location3[i1] # will replace match "pnod*" acconrdingly with the other column (isolate)

# ad a column from global file that contains the country id per isolate
global_file_populations <- select(global_file, isolate, species) # it will reduce the df with original names
i1 <- match(PCA_all_pc$Taxa, global_file_populations$isolate) # will match "pnod*" names from mydata and global_file
PCA_all_pc$species <- global_file_populations$species[i1] # will replace match "pnod*" acconrdingly with the other column (isolate)

# correct name of South Africa
unique(PCA_all_pc$population_country)
PCA_all_pc$population_country <- gsub("SouthAfrica","South Africa", PCA_all_pc$population_country)

# plot
ggplot(PCA_all_pc, aes(x=PC1, y=PC2, colour = population_country)) + geom_point() + theme_minimal()
#ggsave(file = paste0("PCA_366_country.pdf"), width = 8, height = 5, dpi = 300, units = "in", device='pdf', useDingbats=F)

# set colors - This scheme will highligh populations other than USA (which will be in grey)
pop_cuntry_Pallete <- c("Australia" = "black", "China" = "Red", "Switzerland" = "blue", "Iran" = "yellow", "USA" = "grey", "South Africa" = "pink", "Finland" = "orange", "Sweden" = "purple", "Canada" = "#800000", "Brazil" = "#469990")

# plot
ggplot(PCA_all_pc, aes(x=PC1, y=PC2, colour = population_country)) + geom_point(size = 2)  + theme_minimal(base_size = 14) + 
  labs(fill = "Population") + scale_color_manual(values=pop_cuntry_Pallete) + geom_vline(xintercept = 0) + geom_hline(yintercept = 0) + scale_y_continuous(breaks=c(-50,0,50,100,150))
ggsave(file = paste0("PCA_366_country.png"), width = 8, height = 5, dpi = 300, units = "in", device='png')

# end
