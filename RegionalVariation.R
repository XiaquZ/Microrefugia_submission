# Check regional variation in the MIs of Meerdaal.
library(terra)

# Load the shapefile of Meerdaal.
meerdaal <- vect("E:/EuropeShapefile/Meerdaal/Meerdaal_LAEA_epsg3035.shp")

# Load the MI of Meerdaal.
fvomc <- rast(
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_fvocc_75kmBuffer_Res25m_meerdaal.tif"
)
bvomc <- rast(
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_bvocc_75kmBuffer_Res25m_meerdaal.tif"
)
max <- rast(
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_MaxTOffset_V2_crop_Res25m_meerdaal.tif"
    )
min <- rast(
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_MinTOffset_V2_crop_Res25m_meerdaal.tif"
    )
warmmag <- rast(
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_warmingMag_Res25m_meerdaal.tif"
    )

# Extract the MI based on xy coordinates.
# Extract 10,000 rows for linear regression.
mi_stack <- c(fvomc, bvomc, max, min, warmmag)
set.seed(123)
x <- spatSample(mi_stack, 10000, xy = TRUE, "regular", na.rm = TRUE)
colnames(x) <- c("x", "y", "fvomc", "bvomc", "max", "min", "warmmag")	
head(x)

# Extract predictors based on xy coordinates.
xy <- cbind(x$x, x$y)
# Load the predictor layers.
cover <- rast("E:/Input/Predictors/cover.tif")
slope <- rast("E:/Input/Predictors/slope.tif")

# Extra the predictor values.
meerdaal_s <- x
meerdaal_s$cover <- extract(cover, xy)$cover
meerdaal_s$slope <- extract(slope, xy)$slope
head(meerdaal_s)
plot(meerdaal_s$bvomc, meerdaal_s$cover)
plot(meerdaal_s$fvomc, meerdaal_s$slope)
