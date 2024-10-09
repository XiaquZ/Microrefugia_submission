library(terra)

######################
####Rescaling VoMC####
######################
# r <- rast("/lustre1/scratch/348/vsc34871/output/FVoCC_75kmSR_25m_2010-2085_SSP370.tif")
# ##Recall number from command line
# arguments = commandArgs(trailingOnly = TRUE) #FOR HPC
# number = arguments[1] #FOR HPC
# 
# tile <- paste0("/lustre1/scratch/348/vsc34871/output/Tiles/FVoCC_75kmSR_", number, ".tif")
# print(tile)
# 
# ##Calculate the quantile values.
# quantiles <- spatSample(r, 10^6, "regular")
# qnt <- quantile(quantiles, probs = c(0.05, 0.95), na.rm = TRUE) |> unlist()
# qrng <- diff(qnt) #max-min
# 
# ##Rescaling function (use inverse normalisation for forward velocity)
# rescaler1 <- function(f){
#   x <- rast(f)
#   norm <- (qnt[2]-x)/qrng 
#   #qnt[2] is the 0.95 quantile, which is the maximum to put in normalization. 
#   #qnt[1] is the minimum value to use in the normalization.
#   rcl <- rbind(c(-Inf, qnt[1], 1), c(qnt[2], Inf, 0))
#   cls <- classify(x, rcl, other=NA)
#   cover(cls, norm) |> round(1)
# }
# 
# MI <- rescaler1(tile)
# 
# #Save data
# writeRaster(MI, paste0("/lustre1/scratch/348/vsc34871/output/MI_tile/FVoCC_75kmSR_MIs_",number , ".tif"), overwrite = TRUE)

###################################
#####Maximum temperature offset####
###################################
##Recall number from command line
arguments = commandArgs(trailingOnly = TRUE) #FOR HPC
number = arguments[1] #FOR HPC

##read in the tile##
tile <- paste0("/lustre1/scratch/348/vsc34871/output/Tiles/MinToffset_", number, ".tif")
print(tile)

# ##rescaling function for maximumT offset##
# rescaler1 <- function(f){
#   x <- rast(f)
#   rcl <- rbind(c(0, Inf, 0))
#   cls <- classify(x, rcl)
#   laps <- minmax(cls)|> unlist()
#   dif <- diff(laps)
#   (laps[2]-cls)/dif |> round(1) #inverse normalized
# } 
# 
# MI <- rescaler1(tile)
# #Save data
# writeRaster(MI, paste0("/lustre1/scratch/348/vsc34871/output/MI_tile/MaxToffset_MIs_",number , ".tif"), overwrite = TRUE)

##rescaling function for minimum Temp offset##
rescaler1 <- function(f){
  x <- rast(f)
  rcl <- rbind(c(-Inf, 0, 0))
  cls <- classify(x, rcl)
  laps <- minmax(cls)|> unlist()
  dif <- diff(laps)
  (cls-laps[1])/dif |> round(1) #normarlization
} 

MI <- rescaler1(tile)
#Save data
writeRaster(MI, paste0("/lustre1/scratch/348/vsc34871/output/MI_min_tile/MinToffset_MIs_",number , ".tif"), overwrite = TRUE)
