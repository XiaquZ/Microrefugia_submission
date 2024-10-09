####Calculate mean of different months.
library(terra)

##Calculate the mean of max temp during summer.
Max_06 <- rast('/lustre1/scratch/348/vsc34871/input/MIs/maxT_offset_June.tif')
Max_07 <- rast('/lustre1/scratch/348/vsc34871/input/MIs/maxT_offset_July.tif')
Max_08 <- rast('/lustre1/scratch/348/vsc34871/input/MIs/maxT_offset_August.tif')

stack_Max <- c(Max_06,Max_07,Max_08)
mean_Max <- terra::app(stack_Max,mean)

writeRaster(mean_Max, filename = "/lustre1/scratch/348/vsc34871/output/mean_ForestTempMaxT_V3.tif", overwrite = TRUE)

