library(terra)

##Build VRT files

# t.lst <- list.files("/lustre1/scratch/348/vsc34871/output/MI_tile/", pattern=".tif", full.names=TRUE)
# MIs_vrt <- vrt(t.lst, overwrite = TRUE)
# writeRaster(MIs_vrt, filename = "/lustre1/scratch/348/vsc34871/output/MI_final/MI_MinTOffset.tif", overwrite= TRUE)
# show(MIs_vrt)

t.lst <- list.files("/lustre1/scratch/348/vsc34871/output/MI_tile/", pattern=".tif", full.names=TRUE)
MIs <- function(t.lst, fout="") {
  r <- vrt(t.lst)
  if (fout != "") {
    writeRaster(r, fout, overwrite=TRUE)
    fout
  } else {
    wrap(r)
  }
} 

MIs(t.lst, fout = "/lustre1/scratch/348/vsc34871/output/MI_final/MI_FVoCC_75km_25m.tif")