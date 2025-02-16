library(pwr)

# Load your dataset
your_dataset <- read.csv("C:/Users/pshru/OneDrive/Desktop/R/instgram.csv")

# Convert relevant columns to numeric
your_dataset$Followers <- as.numeric(gsub("[^0-9.]", "", your_dataset$Followers)) / 
  ifelse(grepl("M", your_dataset$Followers), 1e6, 1e3)

your_dataset$Avg_Likes <- as.numeric(gsub("[^0-9.]", "", your_dataset$Avg_Likes))

# Remove rows with NAs
your_dataset <- na.omit(your_dataset)

str(your_dataset)

# Calculate the effect size (Cohen's d) based on your data
effect_size <- (mean(your_dataset$Followers) - mean(your_dataset$Avg_Likes)) / 
  sqrt((sd(your_dataset$Followers)^2 + sd(your_dataset$Avg_Likes)^2) / 2)

# Set desired power and significance level
alpha <- 0.05  # Significance level
power <- 0.8   # Desired power

# Calculate sample size based on effect size, alpha, and power
sample_size <- pwr.t.test(
  d = effect_size,
  sig.level = alpha,
  power = power,
  alternative = "two.sided"
)

# Print the required sample size
cat("Required sample size:", ceiling(sample_size$n), "\n")

# Define a range of effect sizes, significance levels, and power levels
effect_sizes <- c(0.1, 0.3, 0.5)  # Example effect sizes
significance_levels <- c(0.01, 0.05, 0.1)  # Example significance levels
desired_powers <- c(0.8, 0.9, 0.95)  # Example desired powers

# Create empty lists to store results
results <- list()

# Perform power analysis for each combination of parameters
for (effect_size in effect_sizes) {
  for (significance_level in significance_levels) {
    for (desired_power in desired_powers) {
      sample_size <- pwr.t.test(
        d = effect_size,
        sig.level = significance_level,
        power = desired_power,
        alternative = "two.sided"
      )
      results[[paste("Effect_Size", effect_size, "_Significance_Level", significance_level, "_Power", desired_power)]] <- ceiling(sample_size$n)
    }
  }
}

# Create a dataframe to store the results
power_results_df <- as.data.frame(t(results))
rownames(power_results_df) <- NULL

# Print the dataframe
print(power_results_df)




# Create a dataframe to store the results
power_results_df <- data.frame(
  Effect_Size = numeric(),
  Significance_Level = numeric(),
  Power = numeric(),
  Sample_Size = numeric(),
  stringsAsFactors = FALSE
)

# Populate the dataframe with results
for (effect_size in effect_sizes) {
  for (significance_level in significance_levels) {
    for (desired_power in desired_powers) {
      sample_size <- pwr.t.test(
        d = effect_size,
        sig.level = significance_level,
        power = desired_power,
        alternative = "two.sided"
      )
      
      # Append to the dataframe
      power_results_df <- rbind(power_results_df, c(
        effect_size,
        significance_level,
        desired_power,
        ceiling(sample_size$n)
      ))
    }
  }
}

# Rename columns
colnames(power_results_df) <- c("Effect_Size", "Significance_Level", "Power", "Sample_Size")

# Print the dataframe
print(power_results_df)
