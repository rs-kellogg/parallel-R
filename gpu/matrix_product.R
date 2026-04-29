##########################
# Parallelization on GPUs
########################## 
# Example Below - Matrix Multiplication using R Torch on CPU vs GPU (A100)

# GPU Use Cases: any task that does not require sequential logic and can be broken down into many 
# independent calculations (embarrassingly parallel tasks). Examples include:
# - matrix multiplications - the core of most deep learning operations
# - image processing (applying filters to pixels) - since the math on the top-left pixel doesn't depend on the bottom-right pixel,
#   the GPU can calculate all pixels simultaneously
# - Monte Carlo simulations (running 100,000 independent "what-if" scenarios like stock market paths - since each path is 
#independent, the GPU runs thousands at once
# - text tokenization/embedding (converting thousands of words into numerical vectors for an LLM) - since each word can be 
# processed independently, the GPU can handle them in parallel


# libraries
library(torch)
library(tictoc)

# 1. Configuration
n <- 25000 
cat("Comparing CPU vs GPU for a", n, "x", n, "matrix multiplication...\n\n")

# --- PHASE 1: Generate Data ---
# 1. Create the data ONCE on the CPU
torch_manual_seed(42)
a_cpu <- torch_randn(c(n, n), device = "cpu")
b_cpu <- torch_randn(c(n, n), device = "cpu")

# 2. Clone that data to the GPU
# This physically copies the 2.3GB of data to the A100's memory
a_gpu <- a_cpu$to(device = "cuda")
b_gpu <- b_cpu$to(device = "cuda")


# --- PHASE 2: CPU TEST ---
cat("Running on CPU...\n")

tic("CPU Total Time")
result_cpu <- torch_mm(a_cpu, b_cpu)
# Force the CPU to finish the calculation
invisible(as.numeric(result_cpu[1,1])) 
cpu_time <- toc()

rm(b_cpu, result_cpu); gc()

# --- PHASE 3: GPU TEST ---
cat("\nRunning on GPU (A100)...\n")

tic("GPU Total Time")
result_gpu <- torch_mm(a_gpu, b_gpu)
# Pull one value back to CPU to ensure the GPU is actually finished
invisible(as.numeric(result_gpu[1,1]$cpu()))
# tell the GPU to wait until it is 100% done
#torch_cuda_synchronize()

gpu_time <- toc()

rm(b_gpu, result_gpu); gc()


# --- PHASE 4: THE RESULTS ---
cat("\n--- FINAL COMPARISON ---\n")
s_cpu <- cpu_time$toc - cpu_time$tic
s_gpu <- gpu_time$toc - gpu_time$tic

cat(sprintf("CPU Time: %.2f minutes (%.1f seconds)\n", s_cpu / 60, s_cpu))
cat(sprintf("GPU Time: %.2f seconds\n", s_gpu))
cat(sprintf("The GPU was %.1f times faster than the CPU!\n", s_cpu / s_gpu))


# --- PHASE 5: CHECK MATRICES  ---
cat("\n--- Integrity Check ---\n")
sum_cpu <- as.numeric(a_cpu$sum())
sum_gpu <- as.numeric(a_gpu$sum()$cpu())

# isTRUE() converts the result of all.equal into a simple TRUE/FALSE
if (isTRUE(all.equal(sum_cpu, sum_gpu, tolerance = 1e-4))) {
    cat("VERIFIED: The matrices are identical.\n")
} else {
    cat(sprintf("DIFFERENCE DETECTED: Ratio is %.2f\n", sum_gpu / sum_cpu))
}
