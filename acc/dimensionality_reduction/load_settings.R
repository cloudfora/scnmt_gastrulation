io <- list()
opts <- list()

################
## Define I/O ##
################

if (grepl("ricard",Sys.info()['nodename'])) {
  io$basedir <- "/Users/ricard/data/gastrulation"
} else {
  io$basedir <- "/hps/nobackup/stegle/users/ricard/gastrulation"
}
io$sample.metadata <- paste0(io$basedir,"/sample_metadata.txt")
io$data.dir <- paste0(io$basedir,"/acc/feature_level")
io$outdir <- paste0(io$basedir,"/acc/dimensionality_reduction")

####################
## Define options ##
####################

# Define which annotations to look at
opts$annos <- c(
  # "genebody"="Gene body",
  # "prom_2000_2000"="Promoters",
  "ESC_DHS"="DHS"
  # "window2000_step1000"="window2000_step1000"
)

# Define which stage and lineages to use
opts$stage_lineage <- c(
  
  # E4.5
  # "E4.5_Epiblast",
  # "E4.5_Primitive_endoderm"
  
  # E5.5
  # "E5.5_Epiblast",
  # "E5.5_Visceral_endoderm"
  
  # E6.5
  # "E6.5_Epiblast",
  # "E6.5_Primitive_Streak",
  # "E6.5_Mesoderm",
  # "E6.5_Visceral_endoderm"
  
  # E7.5
  "E7.5_Endoderm",
  "E7.5_Mesoderm",
  "E7.5_Ectoderm"
)

# Define lineage colors
opts$colors <- c(
  ExE="#fc8d62", 
  Embryonic="#8da0cb", 
  Epiblast="#63B8FF",
  Ectoderm="steelblue",
  Mesoderm="#CD3278",
  Primitive_Streak="sandybrown",
  Endoderm="#43CD80"
)


# Filtering options
opts$min.GpCs <- 5         # minimum number of GpCs per feature in each cell
opts$min.coverage <- 0.20  # minimum coverage per feature (fraction of cells with at least opts$min.GpC measurements)
opts$nfeatures <- 10000     # maximum number of features per view (filter based on variance)

# Define which cells to use
opts$cells <- fread(io$sample.metadata) %>% 
  .[,stage_lineage:=paste(stage,lineage10x_2,sep="_")] %>%
  .[pass_accQC==T & stage_lineage%in%opts$stage_lineage,id_acc] %>% as.character()

# Define output file
io$outfile = sprintf("%s/hdf5/model_%s_%s.hdf5",io$outdir,paste(names(opts$annos), collapse="_"), paste(opts$stage_lineage, collapse="_"))


##########################
## Load sample metadata ##
##########################

sample_metadata <- fread(io$sample.metadata) %>% 
  .[id_acc%in%opts$cells] %>% .[,c("id_acc","stage","lineage10x_2")] %>%
  .[,stage_lineage:=as.factor(paste(stage,lineage10x_2,sep="_"))]