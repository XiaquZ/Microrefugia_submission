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
x <- spatSample(mi_stack, 10000, xy = TRUE, "regular", na.rm = TRUE)
colnames(x) <- c("x", "y", "fvomc", "bvomc", "max", "min", "warmmag")	
head(x)

# Load the predictor layers.

# Crop the predictor layers of Meerdaal.