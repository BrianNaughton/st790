library(gputools)
# nnmfGPU() implements the nnmf() function using GPU utilities from the 
# gputools package. I use the following function:
# gpuCrossprod() is a wrapper for the CUBLAS function: cublasSgemm
# gpuMatMult() is a wrapper for the CUBLAS fucntion: cublasDgemm
nnmfGPU <- function(X, r, V=NULL, W=NULL, tol=10e-4) {
  m <- nrow(X)  
  n <- ncol(X)
  # Use starting values of all 1's if not provided
  if (is.null(V)) V <- matrix(1, m, r) 
  if (is.null(W)) W <- matrix(1, r, n)
  B = gpuMatMult(V, W) 
  notConverged = TRUE
  oldLoss <- 1e5
  iter <- 0
  while (notConverged) {
    iter   <- iter +1
    V <- V * gpuTcrossprod(X,W) / gpuTcrossprod(B,W)
    B <- gpuMatMult(V, W) 
    W <- W * gpuCrossprod(V, X) / gpuCrossprod(V, B)
    B <- gpuMatMult(V, W) 
    newLoss <- sum((X - B)^2) # Frobenius norm
    objectiveValue <- abs(newLoss - oldLoss) / (oldLoss + 1)
    if (objectiveValue <= tol) notConverged  <- FALSE
    oldLoss <- newLoss
  }
  return (list(V=V, W=W, objValue=objectiveValue))
}

path <- 'http://hua-zhou.github.io/teaching/st790-2015spr/'
X <- as.matrix(read.table(paste(path, 'nnmf-2429-by-361-face.txt', sep='')))
V <- as.matrix(read.table(paste(path, 'V0.txt', sep='')))
W <- as.matrix(read.table(paste(path, 'W0.txt', sep='')))
ranks <- c(10, 20, 30, 40, 50)
timingsGPU <- rep(0, 5)
names(timingsGPU) <- as.character(ranks)
for (i in 1:5) {
  r <- ranks[i]
  timingsGPU[i] <- system.time(nnmfGPU(X, r, V[, 1:r], W[1:r, ]))['elapsed']
}

# Remove all variables except for timingsGPU
rm(list=setdiff(ls(), 'timingsGPU'))
save.image('nnmfGPU.Rdata')
