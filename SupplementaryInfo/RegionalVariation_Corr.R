# Check regional variation in the MIs of Meerdaal.
library(terra)

# Load the shapefile of Meerdaal.
meerdaal <- vect("H:/EuropeShapefile/")

# Load the MI of Meerdaal.
mi.fvomc <- rast(
    "H:/Output/MicrorefugiaIndex/VoCC/MI_fvocc_75km_25m_add0.tif"
)
mi.bvomc <- rast(
    "H:/Output/MicrorefugiaIndex/VoCC/MI_bvocc_75km_25m_add0.tif"
)
mi.max <- rast(
    "H:/Output/MicrorefugiaIndex/Offset/MI_MaxTOffset_V2_crop.tif"
    )
mi.min <- rast(
    "H:/Output/MicrorefugiaIndex/Offset/MI_MinTOffset_V2_crop.tif"
    )
mi.warmmag <- rast(
    "H:/Output/MicrorefugiaIndex/MI_WarmingMagnitude.tif"
    )

# Extract the MI based on xy coordinates.
# Extract 10,000 rows for linear regression.
mi_stack <- c(mi.fvomc, mi.bvomc, mi.max, mi.min, mi.warmmag)
set.seed(123)
x <- spatSample(mi_stack, 10000, xy = TRUE, "regular", na.rm = TRUE)
colnames(x) <- c("x", "y", "fvomc", "bvomc", "max", "min", "warmmag")	
head(x)

# Extract predictors based on xy coordinates.
xy <- cbind(x$x, x$y)

# Load the predictor layers.
cover <- rast("H:/Input/Predictors/cover.tif")
slope <- rast("H:/Input/Predictors/slope.tif")
coast <- rast("H:/Input/Predictors/coast.tif")
elevation <- rast("H:/Input/Predictors/elevation.tif")
relative_elev <- rast("H:/Input/Predictors/relative_elevation.tif")
type <- rast("H:/Input/Predictors/type.tif")


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
svg("I:/SVG/Cor_matrix_MIs_predictors.svg")

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
