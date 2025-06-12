# Check regional variation in the MIs of Meerdaal.
library(terra)

# Load the shapefile of Meerdaal.
meerdaal <- vect("H:/EuropeShapefile/Meerdaal/Meerdaal_LAEA_epsg3035.shp")

# Load the MI of European forests.
mi.fvomc <- rast(
    "H:/Output/MicrorefugiaIndex/VoMC/MI_fvomc_mergeForestMI_V2_crop.tif"
)
mi.bvomc <- rast(
    "H:/Output/MicrorefugiaIndex/VoMC/MI_bvomc_mergeForestMI_V2_crop.tif"
)
mi.max <- rast(
    "H:/Output/MicrorefugiaIndex/Offset/MI_MaxTOffset_V2_crop.tif"
    )
mi.min <- rast(
    "H:/Output/MicrorefugiaIndex/Offset/MI_MinTOffset_V2_crop.tif"
    )
mi.warmmag <- rast(
    "H:/Output/MicrorefugiaIndex/MI_microwarming_V2_25m_crop.tif"
    )

# Load the MIs of Meerdaal.
mi.fvomc <- rast(
  "H:/Output/MicrorefugiaIndex/Meerdaal/MI_fvomc_v2_75kmBuffer_Res25m_meerdaal.tif"
)
mi.bvomc <- rast(
  "H:/Output/MicrorefugiaIndex/Meerdaal/MI_bvocc_v2_75kmBuffer_Res25m_meerdaal.tif"
)
mi.max <- rast(
  "H:/Output/MicrorefugiaIndex/Meerdaal/MI_MaxTOffset_V2_crop_Res25m_meerdaal.tif"
)
mi.min <- rast(
  "H:/Output/MicrorefugiaIndex/Meerdaal/MI_MinTOffset_V2_crop_Res25m_meerdaal.tif"
)
mi.warmmag <- rast(
  "H:/Output/MicrorefugiaIndex/Meerdaal/MI_warmingMag_v2_Res25m_meerdaal.tif"
)

# Extract the MI based on xy coordinates.
# Extract 10,000 rows for linear regression.
mi_stack <- c(mi.fvomc, mi.bvomc, mi.max, mi.min, mi.warmmag)
set.seed(123)
x <- spatSample(mi_stack, 3000, xy = TRUE, "random", na.rm = TRUE, exhaustive=TRUE)
colnames(x) <- c("x", "y", "fvomc", "bvomc", "max", "min", "warmmag")	
head(x)

# Extract predictors based on xy coordinates.
xy <- cbind(x$x, x$y)

# Load the predictor layers.
cover <- rast("H:/Input/Predictors_microclimate/cover.tif")
slope <- rast("H:/Input/Predictors_microclimate/slope.tif")
coast <- rast("H:/Input/Predictors_microclimate/coast.tif")
elevation <- rast("H:/Input/Predictors_microclimate/elevation.tif")
relative_elev <- rast("H:/Input/Predictors_microclimate/relative_elevation.tif")
type <- rast("H:/Input/Predictors_microclimate/type.tif")


# Extra the predictor values.
x[, 8] <- extract(cover, xy)|> round(digits = 1)
x[, 9] <- extract(slope, xy) |> round(digits = 1)
x[, 10] <- extract(coast, xy) |> round(digits = 1)
x[, 11] <- extract(elevation, xy) |> round(digits = 1)
x[, 12] <- extract(relative_elev, xy) |> round(digits = 1)
x[, 13] <- extract(type, xy) 
head(x)
str(x)
class(x$type) <- as.integer(x$type)

#### Correlation test.####
library(ggcorrplot)
library(dplyr)

# Select the relevant variables for correlation
df_selected <- x[, 3:13]  # Keeping only the relevant columns

# Function to compute p-values for correlation matrix
cor.mtest <- function(mat, method = "spearman") {
  n <- ncol(mat)
  p.mat <- matrix(NA, n, n)
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      test <- cor.test(mat[, i], mat[, j], method = method, use = "pairwise.complete.obs")
      p.mat[i, j] <- p.mat[j, i] <- test$p.value
    }
  }
  diag(p.mat) <- 0  # Self-correlation has no p-value
  return(p.mat)
}


# Compute Spearman correlation matrix
cor_matrix <- cor(df_selected, method = "spearman", use = "pairwise.complete.obs")

# Compute p-values
p_matrix <- cor.mtest(df_selected, method = "spearman")

# Define new variable names
new_names <- c("MI: FVoMC", "MI: BVoMC", "MI: MaxTempOffset", "MI: MinTempOffset", "MI: MicroWarming", 
               "Tree Cover Density", "Slope", "Distance to the coast", "Elevation", "Relative Elevation",
               "Forest type")

# Rename the correlation matrix
colnames(cor_matrix) <- rownames(cor_matrix) <- new_names

# Create correlation plot with significance mask
svg("I:/SVG/Cor_matrix_MIs_predictors_meerdaal forests.svg")

ggcorrplot(cor_matrix, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3.5, 
           show.diag = FALSE, 
           p.mat = p_matrix,  # Add p-values
           sig.level = 0.05,  # Only show significant correlations (p < 0.05)
           insig = "blank",   # Hide non-significant values
           colors = c("blue", "white", "red"))  # Adjust colors

dev.off()
