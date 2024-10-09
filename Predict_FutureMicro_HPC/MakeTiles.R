library(terra)
library(sf)
# max_offset <- rast("E:/Output/ForestTempOffset/mean/mean_ForestTempMaxTOffset_V3.tif")
minT <- rast("/lustre1/scratch/348/vsc34871/input/mean_ForestTempMinOffset_V3.tif")
print(minT)

#Read in data in sf format.
c_shape <- read_sf("/lustre1/scratch/348/vsc34871/input/Shapefile/Europe.shp") #change pathway if change to another country

# create an initial grid for centroid determination
c_grid <- st_make_grid(c_shape, cellsize = c(6e5, 6e5), square = TRUE) |>
  st_as_sf()
# inspect
plot(st_geometry(c_shape))
plot(st_geometry(c_grid), border = "red", add = TRUE)

c_grid_spat <- vect(c_grid)

## Making tiles:
filename <- paste0("/lustre1/scratch/348/vsc34871/output/Tiles/MinToffset", "_.tif") #Change path
tile <- makeTiles(minT,c_grid_spat, filename, overwrite = TRUE)
