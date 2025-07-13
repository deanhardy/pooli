################################################
## PURPOSE: Downloading and visualizing pool maintenance data
## BY: Dean Hardy
################################################
rm(list=ls())

## API tutorials for R & Pooli
# https://www.dataquest.io/blog/r-api-tutorial/
# https://pooli.app/api-documentation/

# install.packages(c("httr2", "jsonlite"))
# devtools::install_github("hrbrmstr/curlconverter")

library(httr2)
library(jsonlite)
library(curlconverter)
library(tidyverse)

headers = c(
  Authorization = "Bearer ",
  `Content-Type` = "application/json"
)
res <- httr::GET(url = "https://us-central1-pooli-19f1c.cloudfunctions.net/api/v1//pools//logs", httr::add_headers(.headers=headers))

data = fromJSON(rawToChar(res$content))
names(data)
data$type

df <- data %>%
  filter(type == 'product')

df2 <- unnest(df, cols = c(createdAt, solution, solutionContent, updatedAt, maintenances,
                           attachments, chemicalReading, equipmentReading, relatedProblems, targets), names_sep = ".")
str(df2)

df3 <- df2 %>%
  mutate(datetime = as_datetime(createdAt._seconds))
