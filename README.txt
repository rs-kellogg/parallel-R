#################
# parallel-R Repo
#################
This repo provides instructions and sample code for parallelizing R scripts on KLC.  


The class example involves CPU parallelization.  You'll find these files in the "cpu" subfolder.

1.) cheat_sheet_cpu.txt
text document that provides all the web pages and linux commands covered in the demo

2.) time_trial.R
R file that demonstrates how to parallelize your R code

3.) parallel_check.R
R file that reads the RDS file created by time_trial.R

4.) r_parallel.yml
yaml file you can use to create an R conda environment

GPU parallelization works on different examples. You'll find files for a matrix product parallelization example using a GPU node in the "gpu" subfolder.

5.) cheat_sheet_gpu.txt
text document that provides the steps for creating an r-torch conda environment and running the code on GPU nodes

6.) matrix_product.R
R file that compares running a 25000 x 25000 matrix product on CPUs vs GPUs 

