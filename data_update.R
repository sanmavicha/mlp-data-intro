library(tidyverse)
library(here)
library(psych)

# Path to git repo folder
path_git <- function(...) {
  # # default guess
  # base <- "~/Dropbox/ML for Peace/github-repos"
  
  # jeremy: office windows
  if (Sys.info()["user"]=="jerem") {
    base <- "C:/Users/jerem/Dropbox"
  }
  # jeremy: home linux
  if (Sys.info()["user"]=="jeremy") {
    base <- "/home/jeremy/Dropbox"
  }
  
  # donald
  if(Sys.info()["user"] == "skybl") {
    if(Sys.info()["nodename"] == "DONALDS_DESKTOP"){
      base <- "C:/Users/skybl/Dropbox"
    } else{
      base <- "D:/Dropbox" 
    }
  }
  
  if (Sys.info()["user"]=="mahda.soltani") {
    base <- "/Users/mahda.soltani/Dropbox"
  }
  
  # Check to make sure the directory exists and is correct
  if (!dir.exists(base)) {
    stop("Go edit path_dropbox in R/misc.R and add your path to the Dropbox ml4p.forecasting folder")
  }
  

  
  file.path(base, ...)
}


## Copy misc.R from forecasting app
# file.copy(from = "/home/jeremy/Dropbox/github-repos/ML4P-Civic-Space-Forecasting/ml4p.forecast/R/constants.R", to = here::here("code"), overwrite = TRUE)
# file.copy(from = "/Users/mahda.soltani/ML4P-Civic-Space-Forecasting/ml4p.forecast/R/constants.R", to = here::here("code"), overwrite = TRUE)
# file.copy(from = paste0(path_git,"ML4P-Civic-Space-Forecasting/ml4p.forecast/R/constants.R"), to = here::here("code"), overwrite = TRUE)

########################
## Store updated data

# Specify target folder
today_folder = paste0(here(),"/data/counts")


## Grab data from newly created folder. I don't think this will create any problems
new_files <- dir(paste0(path_git("ML for Peace/ml4p.forecasting/1-normalized-counts")) , full.names = TRUE)
file.copy(from = new_files, to = today_folder, overwrite = TRUE)


# Create single dataframe of all countries
all_files = dir(today_folder, full.names = T)
all_files = all_files[!str_detect(all_files, ".*full-data.*")]
raw <- lapply(all_files, read_csv, col_types = cols())
data <- bind_rows(raw)

# # Drop low-volume months
# unique(data[ data$article_total < 200,]$country)
# data = data %>% filter(!article_total < 200)

saveRDS(data, paste0(today_folder, "/full-data.rds"))
write.csv(data, paste0(today_folder, "/full-data.csv"))
