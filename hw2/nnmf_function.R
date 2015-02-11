## ---- nnmfTag
nnmf <- function(X, r, V=NULL, W=NULL, tol=10e-4) {
  m <- nrow(X)  
  n <- ncol(X)
  # Use starting values of all 1's if not provided
  if (is.null(V)) V <- matrix(1, m, r) 
  if (is.null(W)) W <- matrix(1, r, n)
  B = V %*% W
  notConverged = TRUE
  oldLoss <- 1e5
  iter <- 0
  while (notConverged) {
    iter   <- iter +1
    V <- V * (X %*% t(W)) / (B %*% t(W))
    B <- V %*% W
    W <- W * (t(V) %*% X) / (t(V) %*% B)
    B <- V %*% W
    newLoss <- sum((X - B)^2) # Frobenius norm
    objectiveValue <- abs(newLoss - oldLoss) / (oldLoss + 1)
    if (objectiveValue <= tol) notConverged  <- FALSE
    oldLoss <- newLoss
  }
  return (list(V=V, W=W, objectiveValue=objectiveValue))
}
