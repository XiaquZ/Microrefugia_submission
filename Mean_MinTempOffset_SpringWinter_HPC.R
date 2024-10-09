####Calculate mean of minimum temp offsets.
library(terra)

##Calculate the average of minimum Temp offsets during winter and spring.
# 
# datasets <- c('E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_gfdl-esm4_ssp370_V.2.1.tif',
#               'E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_ipsl-cm6a-lr_ssp370_V.2.1.tif',
#               'E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_mpi-esm1-2-hr_ssp370_V.2.1.tif',
#               'E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_mpi-esm1-2-hr_ssp370_V.2.1.tif',
#               'E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_mri-esm2-0_ssp370_V.2.1.tif',
#               'E:/Input/CHELSAdata/CHELSA(old)V1/ssp370/CHELSA_bio1_2071-2100_ukesm1-0-ll_ssp370_V.2.1.tif')
# output_vector <- mclapply(datasets, rast)
# mean_min <- mclapply(output_vector,mean)

# writeRaster(mean_min, filename = "/lustre1/scratch/348/vsc34871/output/mean_ForestTempMinOffset_V3.tif", overwrite = TRUE)

##Calculate the mean of max temp during summer.
Min_12 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_December.tif')
Min_01 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_January.tif')
Min_02 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_February.tif')
Min_03 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_March.tif')
Min_04 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_April.tif')
Min_05 <- rast('/lustre1/scratch/348/vsc34871/input/minT_offset_May.tif')

stack_min <- c(Min_12,Min_01,Min_02, Min_03, Min_04, Min_05)
mean_min <- terra::app(stack_min,mean)

writeRaster(mean_min, filename = "/lustre1/scratch/348/vsc34871/output/mean_ForestTempMinOffset_V3.tif", overwrite = TRUE)


