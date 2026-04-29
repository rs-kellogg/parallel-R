####################
# Parallelize R Code
####################

# load libraries silently
invisible(capture.output(suppressMessages({
  library(tidyverse)
  library(furrr)
  library(tictoc)
})))

# ---- parallelization demo -----
plan(multicore, workers = 1) # only hire one core for the job
tic()

seq(10) %>% #do 10 jobs

future_walk(~Sys.sleep(5)) # each job tells computer to sleep for 5 seconds

toc() %>% write_rds("time_results.rds")
