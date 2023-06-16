#Preparing the IES data

# Load the "tidyverse" package, which includes a set of tools for data manipulation and visualization
library(tidyverse)

# Import the csv file located at the "data\\ies.csv" path into a dataframe called "df"
df <- read.csv("data\\ies.csv")

# Create a new dataframe "ies" from "df" with only the variables needed for the simulation
ies <- df %>% select(X1PAR1EDU,X1PAR2EDU,X1MTHID,X2MTHID) %>% filter(X1MTHID>-7,X2MTHID>-7,X1PAR1EDU>0,X1PAR2EDU>0) %>%
  mutate(PRSTEM=pmax(X1PAR1EDU,X1PAR2EDU)>=4,
         outcome=as.vector(scale(X2MTHID)),c1=PRSTEM,c2=as.vector(scale(X1MTHID))) %>%
  select(outcome,c1,c2)

# Save the "ies" dataframe as a RDS (R Data Storage) file at the path "data\\ies.rds" for future use
saveRDS(ies,"data\\ies.rds")
  
