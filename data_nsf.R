#Preparing the NSF SDR data

# Load the "tidyverse" package, which includes a set of tools for data manipulation and visualization
library(tidyverse)

# Import the csv file located at "data\\nsf.csv" path into a dataframe "df", filtering only the rows where "SALARY" is between 1 and 150001, and "WRKG" equals 1
df <- read.csv("data\\nsf.csv") %>% filter(between(SALARY,1,150001),WRKG==1) 

# Create a new dataframe "df19" from "df" with the entries from the year 2010, and select only "REFID" and "SALARY", renaming "SALARY" to "SALARY19"
df19 <- df %>% filter(YEAR == 2010) %>% select(REFID,SALARY) %>%
  rename(SALARY19=SALARY)

# Update the "df" dataframe to include only the entries from the year 2013, and join with "df19" using an inner join
df <- df %>% filter(YEAR == 2013) %>% inner_join(df19) 

# Create a new dataframe "temp" by grouping "df" by "NOCPR", calculate a new variable indicating higher paid job categories 
temp <- df %>% group_by(NOCPR) %>% summarise(a=mean(SALARY)) %>% mutate(a=a>100000)

# Create a new dataframe "NSf" from "df" with only the variables needed for the simulation
nsf <- df %>% inner_join(temp) %>% select(GENDER,MINRTY,a,SALARY19,SALARY) %>% mutate(outcome=as.vector(scale(SALARY)),c1=a,c2=as.vector(scale(SALARY19))) %>%
  select(outcome,c1,c2)

# Save the "nsf" dataframe as a RDS (R Data Storage) file at the path "data\\nsf.rds" for future use
saveRDS(nsf,"data\\nsf.rds")