# Load the "tidyverse" package
library(tidyverse)

# Function to generate a correlated binary treatment variable based on two input variables
cor_gen <- function(var1,var2,cor=0){
  
  # Predefined correlation adjustment parameters
  if (cor == 0.3) {p_cal1 <- 0.36;p_cal2 <- 0.378}
  if (cor == 0.5) {p_cal1 <- 0.56;p_cal2 <- 0.653}
  if (cor == -0.3) {p_cal1 <- -0.36;p_cal2 <- -0.378}
  if (cor == -0.5) {p_cal1 <- -0.56;p_cal2 <- -0.653}
  
  # Standardize the existing variables
  var1 <- scale(var1)
  var2 <- scale(var2)
  
  # Compute the latent variable (z) based on the desired correlation structure
  if (cor != 0) z_standardized <- p_cal1 * var1 + p_cal2 * var2 + rnorm(length(var1), sd=sqrt(1 - p_cal1^2 - p_cal2^2))
  if (cor == 0) z_standardized <- rnorm(length(var1))
  # Choose a threshold (e.g., the median to have a balanced binary variable)
  threshold <- median(z_standardized)
  
  # Convert the latent variable to a binary variable
  out <- as.integer(z_standardized > threshold)
  
}

# Load data from RDS files and put them into a list
df <- list(readRDS("data\\mf.rds"),readRDS("data\\ies.rds"),readRDS("data\\nsf.rds"))
df_name <- c("mf","ies","nsf")

# Loop function to run the analysis and return the key results
loop <- function (i,es,n,df) {
  
  # Random seed for reproducibility
  set.seed(i)
  
  temp <- rep(0,8)
  
  # simulate treatment effect
  df2 <- df %>% mutate(outcome2 = outcome+int*es) %>%
    slice(sample(n(),n))
  
  # Fit the models and extract the key results
  fit.aov <- aov(outcome2 ~ int,df2)
  temp[1] <- fit.aov$coefficients[2]
  temp[2] <- summary(fit.aov)[[1]][["Pr(>F)"]][1]
  temp[5] <- (temp[1] - es)^2
  temp[7] <- temp[2] < 0.05 & temp[1] > 0
  
  fit.lm <- lm(outcome2 ~ int+c1+c2,df2)
  temp[3] <- fit.lm$coefficients[2]
  temp[4] <- summary(fit.lm)$coefficients[2,4]
  temp[6] <- (temp[3] - es)^2
  temp[8] <- temp[4] < 0.05 & temp[3] > 0
  
  temp
  
}

# Define the combinations to loop over
comb <- expand.grid(es=c(0.2,0.5,0),n=c(100,200,500),df_id = 1:3)
# number of loops
lc <- 2000

# Function to perform the analysis for each combination
tempf <- function(i,cor){
  
  # Generate the correlated binary variable
  df <- lapply(df,function(x) x %>% mutate(int = cor_gen(c1,c2,cor)))
  
  # Run the loop function for each combination and summarise the results
  rs <- data.frame(t(sapply(1:lc,loop,comb[i,1],comb[i,2],df[[comb[i,3]]]))) %>% 
    summarise_all(mean) %>%
    mutate(es=comb[i,1],n=comb[i,2],name=df_name[comb[i,3]],cor=cor)
  
}

# Define the correlation levels
cor <- c(0,0.3,-0.3,0.5,-0.5)

# Run the analysis for each correlation level and combine the results
tr <- do.call(rbind,lapply(cor, FUN = function(x) do.call(rbind,lapply(1:nrow(comb),tempf,x))))

# Save the results as RDS
saveRDS(tr,"tr.rds")

# Reshape the results and export to CSV
fr <- tr %>% select(X5:cor) %>% pivot_wider(names_from = name, values_from = c(X5,X6,X7,X8)) %>%
  select(cor,n,es,X5_mf,X6_mf,X7_mf,X8_mf,X5_ies,X6_ies,X7_ies,X8_ies,X5_nsf,X6_nsf,X7_nsf,X8_nsf)

write.csv(fr,"results.csv")