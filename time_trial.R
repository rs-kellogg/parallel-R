####################
# Parallelize R Code
####################

# libraries
library(tidyverse)
library(furrr)
library(tictoc)


plan(multisession, workers = 1) #only hire one core for the job
tic()

seq(10) %>% #do 10 jobs

future_walk(~Sys.sleep(5)) #each job tells computer to sleep for 5 seconds

toc() %>% write_rds("time_results.rds")
