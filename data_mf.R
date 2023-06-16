#Preparing the MIDFIELD data

# Load the "tidyverse" package, which includes a set of tools for data manipulation and visualization
library(tidyverse)

# Load the "student" and "term" datasets from the "midfielddata" package
data(student, term, package = "midfielddata")

# Merging the "student" and "term" datasets and remove the missing
term2 <- term %>% select(mcid,cip6,gpa_term) %>%
  left_join(student) %>%
  filter(!is.na(gpa_term),!is.na(act_comp))

# Create a new dataframe "mf" from "df" with only the variables needed for the simulation
mf <- term2 %>% mutate(outcome=as.vector(scale(gpa_term)),c1=sex=="Female",c2=as.vector(scale(act_comp))) %>%
  select(outcome,c1,c2)

# Save the "mf" dataframe as a RDS (R Data Storage) file at the path "data\\mf.rds" for future use
saveRDS(mf,"data\\mf.rds")




