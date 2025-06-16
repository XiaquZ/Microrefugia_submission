library(terra)
library(ggplot2)
library(dplyr)


offset2020 <- rast("H:/Input/ForestTemp_new/01_Offsets/mean_annualOffset.tif")
macro2020 <- rast("H:/Input/CHELSAdata/Recalculated2025/chelsa2000-2019_euforests_25m.tif")
macro2100 <- rast("H:/Input/CHELSAdata/Recalculated2025/Macro2071-2100_euforests_25m.tif")

minmax(macro2020)
minmax(macro2100)
offset2020 <- setMinMax(offset2020)
minmax(offset2020)

###########################
####Extract sample data####
###########################

##Create sample data
s <- c(offset2020,macro2020)
sample.set <- spatSample(s, 10^6, "regular", na.rm = TRUE, xy = TRUE)
head(sample.set)

colnames(sample.set)[3] <- "offset" #Change the column name of data frame
colnames(sample.set)[4] <- "macro2020"
head(sample.set)
plot(sample.set$macro2020, sample.set$offset,pch = 16, cex = 1.3, col = "grey",
     main = "ForestTemp Offset PLOTTED AGAINST Macro temperature",
     xlab = "Macro bio1 CHELSA (1981-2010)",
     ylab = "Mean annual offset")

####Check normal distribution####
hist(sample.set$offset)
hist(sample.set$macro2020)

########################
####Fit linear model####
########################
reg1 <- lm(offset ~ macro2020, data = sample.set )
summary_reg1 <- summary(reg1)
save(reg1, file = "H:/Output/FutureMicro_CHELSA2000_2019/regression_CHELSArecalculated_VS_offset_V2.RData")
###Check for homoscedasticity####
par(mfrow=c(2,2))
plot(reg1)
par(mfrow=c(1,1))

################################
####Plot the model in ggplot####
################################
# Create the plot
load("H:/Output/FutureMicro_CHELSA2000_2019/regression_CHELSArecalculated_VS_offset_V2.RData")
summary_reg1 <- summary(reg1)
# Extract coefficients and R-squared
intercept <- round(coef(reg1)[1], 3)
slope <- round(coef(reg1)[2], 3)
r2 <- round(summary_reg1$r.squared, 3)

# Create formula text
eqn_text <- paste0("y = ", intercept, slope, "x")
r2_text <- paste0("R² = ", r2)
# Compute max x and y for positioning
x_max <- max(sample.set$macro2020, na.rm = TRUE)
y_max <- max(sample.set$offset, na.rm = TRUE)
# Create plot
linear_reg_plot <- ggplot(sample.set, aes(x = macro2020, y = offset)) +
  geom_point(alpha = 0.1, color = "grey30", size = 0.8) +
  geom_smooth(method = "lm", color = "dodgerblue", size = 1.2) +
  annotate("text", x = x_max, y = y_max, label = eqn_text, hjust = 1, size = 5, color = "navy") +
  annotate("text", x = x_max, y = y_max - 0.4, label = r2_text, hjust = 1, size = 5, color = "navy") +
  theme_minimal(base_size = 14) +
  labs(
    title = "Temperature Offset vs Macroclimate temperature",
    x = "Macroclimate bio1 CHELSA (2000-2019)",
    y = "Mean annual temperature offset"
  )

ggsave("I:/SVG/regression_plot.svg", plot = linear_reg_plot, width = 8, height = 6, units = "in")


####Calculate Offset and future micro ForestTemp for future and warming magnitude ####
load("H:/Output/FutureMicro_CHELSA2000_2019/regression_CHELSArecalculated_VS_offset_V2.RData")
summary(reg1)

slope <- -0.065
delta_macro <- macro2100-macro2020

#method Xiaqu
offset2100 <- round(offset2020 + slope * delta_macro, digits = 2)

micro2020 <- macro2020 + offset2020 # macro2020 is CHELSA2000-2019.
micro2100 <- macro2100 + offset2100
delta_micro <- micro2100 - micro2020

#method Koenraad
delta_micro_v2 <- 0.94 * delta_macro
micro2100_v2 <- micro2020 + 0.94 * delta_macro 

#Compare two methods
minmax(micro2020)
minmax(micro2100)
minmax(offset2100)
minmax(delta_micro)

minmax(micro2100_v2)
minmax(delta_micro_v2)


writeRaster(micro2100, "H:/microtemp_future.tif", overwrite=TRUE)
writeRaster(delta_micro, "H:/microwarming.tif", overwrite=TRUE)
writeRaster(offset2100, "H:/offset_future.tif", overwrite=TRUE)

