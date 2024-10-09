library(terra)
library(ggplot2)


offset2020 <- rast("/lustre1/scratch/348/vsc34871/input/mean_annualOffset.tif")
macro2020 <- rast("/lustre1/scratch/348/vsc34871/input/CHELSA_EUForest_1981-2010_25m_bio1_V2.tif")
macro2100 <- rast("/lustre1/scratch/348/vsc34871/input/CHELSA_EUForest_2071-2100_25m_bio1_V2.tif")

offset2020
macro2020
macro2100

###########################
####Extract sample data####
###########################
#SamplesCells <- sampleRandom(OffsetForest, 10000, na.rm = TRUE, sp = TRUE) ##For raster package

##Create sample data
#ext(macro) <- ext(OffsetForest)
# s <- c(offset2020,macro2020)
# x <- spatSample(s, 10^6, "regular", na.rm = TRUE, xy = TRUE)
# head(x)

#SampleOffset <- spatSample(s, 1000, "random", na.rm = TRUE, xy=TRUE)  ##For terra package
# colnames(x)[3] <- "offset" #Change the column name of data frame
# colnames(x)[4] <- "macro2020"
# head(x)
# plot(x$macro2020, x$offset,pch = 16, cex = 1.3, col = "grey", main = "ForestTemp Offset PLOTTED AGAINST Macro temperature", xlab = "Macro bio1 CHELSA (1981-2010)", ylab = "Mean annual offset")

####Check normal distribution####
#hist(SampleOffset$mean_annualOffset)
#hist(SampleOffset$`CHELSA_bio1_1981-2010_V.2.1`)

########################
####Fit linear model####
########################
# reg1 <- lm(offset ~ macro2020, data = x )
# summary(reg1)
# save(reg1, file = "/lustre1/scratch/348/vsc34871/output/FutureMicroData/regression_macroCHELSA_VS_offset.RData")
####Check for homoscedasticity####
# par(mfrow=c(2,2))
# plot(reg1)
# par(mfrow=c(1,1))

################################
####Plot the model in ggplot####
################################
#reg.graph<-ggplot(SampleOffset, aes(x=macro2020, y=offset))+
#  geom_point() +
#  geom_smooth(method="lm", col="black") +
 # stat_regline_equation(label.x = 15, label.y = 2.5)

#reg.graph 

###Train the model by using caret####
# prepare cross-validation folds (10-fold cross validation)
#fitControl <- trainControl(method = "cv", number = 5000, savePredictions = TRUE)

# 10-fold cross-validation of binomial GLM using the caret package
# note that this not the ideal method as we're working with presence-only data
#lmFit <- train(offset ~ macro2020,
                #data = SampleOffset,
                #method = "lm", 
                #trControl = fitControl,
                #na.action = na.exclude)
#summary(lmFit)

#save(lmFit, file = "/vsc-hard-mounts/leuven-data/348/vsc34871/ClimateOffset/Output/Rdata/10foldValidation_lmfit_macroCHELSA_offset.RData")

####Calculate Offset and future micro ForestTemp for future
# load("/vsc-hard-mounts/leuven-data/348/vsc34871/ClimateOffset/Output/Rdata/regression_macroCHELSA_VS_offset.RData")
# summary(reg1)

names(macro2100) <- "macro2100"

slope <- -0.06382
delta_macro <- macro2100-macro2020
offset2100 <- round(offset2020 + slope * delta_macro, digits = 1)
plot(offset2100)

writeRaster(offset2100, filename = "/lustre1/scratch/348/vsc34871/output/PredictedMicroTempOffset_EUForest_SSP370_EPSG3035_25m.tif", overwrite=TRUE)

micro2100 <- round(macro2100 + offset2100, digits = 1)
plot(micro2100)
writeRaster(micro2100, filename = "/lustre1/scratch/348/vsc34871/output/PredictedMicroMAT_2071-2100_EUForest_SSP370_EPSG3035_25m.tif", overwrite=TRUE)




