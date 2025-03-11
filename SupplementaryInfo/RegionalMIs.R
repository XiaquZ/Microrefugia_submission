library(terra)

# Regional variation of microrefugia indices.
mi_fvomc <- rast("E:/Output/MicrorefugiaIndex/VoCC/MI_fvocc_75km_25m_add0.tif")
mi_bvomc <- rast("E:/Output/MicrorefugiaIndex/VoCC/MI_bvocc_75km_25m_add0.tif")
mi_maxoffset <- rast("E:/Output/MicrorefugiaIndex/Offset/MI_MaxTOffset_V2_crop.tif")
mi_minoffset <- rast("E:/Output/MicrorefugiaIndex/Offset/MI_MinTOffset_V2_crop.tif")
mi_warmmag <- rast("E:/Output/MicrorefugiaIndex/MI_WarmingMagnitude.tif")

# Load regional shapefiles
sd <- vect("E:/EuropeShapefile/Shapefiles/Sweden.shp")
meerdaal <- vect(
    "H:/EuropeShapefile/Meerdaal/ANB-grenzen-betanden-Meerdaalwoud-zonder-wegen.shp"
    )
meerdaal <- project(meerdaal, crs(sd))
plot(meerdaal)
writeVector(meerdaal,
"E:/EuropeShapefile/Meerdaal/Meerdaal_LAEA_epsg3035.shp",
overwrite = TRUE)

# MI-Forward VoMC
# Sweden
sd_fv <- crop(fvomc, sd)
sd_fv <- mask(sd_fv, sd)
plot(sd_fv)
writeRaster(
    sd_fv,
    "E:/Output/MicrorefugiaIndex/Sweden/MI_fvocc_75kmBuffer_Res25m_sweden.tif",
    overwrite = TRUE
)
# Meerdaal
md_fv <- crop(fvomc, meerdaal)
md_fv <- mask(md_fv, meerdaal)
plot(md_fv)
writeRaster(
    md_fv,
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_fvocc_75kmBuffer_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# MI-Backward VoMC
# Sweden
sd_bv <- crop(bvomc, sd)
sd_bv <- mask(sd_bv, sd)
plot(sd_bv)
writeRaster(
    sd_bv,
    "E:/Output/MicrorefugiaIndex/VoCC/Sweden/MI_bvocc_75kmBuffer_Res25m_sweden.tif",
    overwrite = TRUE
)
# Meerdaal
md_bv <- crop(bvomc, meerdaal)
md_bv <- mask(md_bv, meerdaal)
plot(md_bv)
writeRaster(
    md_bv,
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_bvocc_75kmBuffer_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# MI: Maximum temperature offset during summer time
sd_maxtemp <- crop(maxoffset, sd)
sd_maxtemp <- mask(sd_maxtemp,sd)
plot(sd_maxtemp)
writeRaster(
    sd_maxtemp,
    "E:/Output/MicrorefugiaIndex/Sweden/MI_MaxTOffset_V2_crop_sweden_25m.tif",
    overwrite = TRUE
)
# Meerdaal
md_max <- crop(maxoffset, meerdaal)
md_max <- mask(md_max, meerdaal)
plot(md_max)
writeRaster(
    md_max,
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_MaxTOffset_V2_crop_75kmBuffer_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# MI: Minmum temperature offset during winter time
sd_mintemp <- crop(minoffset, sd)
sd_mintemp <- mask(sd_mintemp, sd)
plot(sd_mintemp)
writeRaster(
    sd_mintemp,
    "E:/Output/MicrorefugiaIndex/Sweden/MI_MinTOffset_V2_crop_sweden_25m.tif",
    overwrite = TRUE
)
# Meerdaal
md_min <- crop(minoffset, meerdaal)
md_min <- mask(md_min, meerdaal)
plot(md_min)
writeRaster(
    md_min,
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_MinTOffset_V2_crop_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# MI: Warming magnitude
sd_wm <- crop(warmmag, sd)
sd_wm <- mask(sd_wm, sd)
plot(sd_wm)
writeRaster(
    sd_wm,
    "E:/Output/MicrorefugiaIndex/Sweden/MI_warmingMag_sweden_25m.tif",
    overwrite = TRUE
)
# Meerdaal
md_wm <- crop(warmmag, meerdaal)
md_wm <- mask(md_wm, meerdaal)
plot(md_wm)
writeRaster(
    md_wm,
    "E:/Output/MicrorefugiaIndex/Meerdaal/MI_warmingMag_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# Multifunctionality index
mf_single <- rast("E:/Output/Multifunctionality/MF_singleT0.8_EU_25m_EPSG3035.tif")
mf_ave <- rast("E:/Output/Multifunctionality/MF_average_5MIs_25m_V2.tif")

# Single threshold multifunctionality.
# Sweden
sd_mfsingle <- crop(mf_single, sd)
sd_mfsingle <- mask(sd_mfsingle, sd)
plot(sd_mfsingle)
writeRaster(
    sd_mfsingle,
    "E:/Output/MicrorefugiaIndex/VoCC/Sweden/MF_singleT0.8_75kmBuffer_Res25m_sweden.tif",
    overwrite = TRUE
)
#Meerdaal
md_singleT <- crop(mf_single, meerdaal)
md_singleT <- mask(md_singleT, meerdaal)
plot(md_singleT)
writeRaster(
    md_singleT,
    "E:/Output/Multifunctionality/Meerdaal/MF_singleT0.8_Res25m_meerdaal.tif",
    overwrite = TRUE
)

# Average multifunctionality
# Sweden
sd_mfave <- crop(mf_ave, sd)
sd_mfave <- mask(sd_mfave, sd)
plot(sd_mfave)
writeRaster(
    sd_mfave,
    "E:/Output/MicrorefugiaIndex/VoCC/Sweden/MF_average_75kmBuffer_Res25m_sweden.tif",
    overwrite = TRUE
)
# Meerdaal
md_ave <- crop(mf_ave, meerdaal)
md_ave <- mask(md_ave, meerdaal)
plot(md_ave)
writeRaster(
    md_ave,
    "E:/Output/Multifunctionality/Meerdaal/MF_average_Res25m_meerdaal.tif",
    overwrite = TRUE
)

#### Convert Meerdaal to data point. ####
meerdaal_centroid <- centroids(meerdaal)
writeVector(meerdaal_centroid,
            "H:/EuropeShapefile/Meerdaal/meerdaal_centroid.shp",
            overwrite = TRUE)
