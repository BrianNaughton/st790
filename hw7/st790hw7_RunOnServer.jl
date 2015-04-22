print("versioninfo() \n")
versioninfo()

### 1a
# Fit Lasso using Convex Optimization solver
using Convex, Mosek
solver = MosekSolver(LOG=0)
set_default_solver(solver)

function lasso_convex(X, y, λ)
  β = Variable(size(X, 2))
  problem = minimize(0.5 * norm(y- X*β, 2)^2 + λ * norm(β[2:end], 1))
  solve!(problem)
  return β.value
end

### 1b
# soft-thresholding function
function softThresh(z, γ)
  sign(z) * max(abs(z) - γ, 0)
end

function lasso_cd(X, y, λ, tol, β = (y \ X)')
  currObj = .001
  prevObj = .001
  x1 = X[1, 1] # Assumes X[:,1] = x1
  p = size(X, 2)
  XjpXj = zeros(p)
  for j = 1:p # faster than diag(X'X)
    XjpXj[j] = norm(X[:,j])^2
  end
  n = size(X, 1)
  r = vec(y - X * β)
  iters = 0
  while abs(currObj - prevObj)/prevObj  > tol || iters == 0
    prevObj = copy(currObj)
    # Update β_0:
      βnew = β[1] + mean(r) / x1
      r = r .+ ((β[1] - βnew)*x1)
      β[1] = βnew
    # Update β_j's
      for j = 2:p
        z = β[j] + dot(X[:,j], r) / XjpXj[j]
        βnew = softThresh(z, λ / XjpXj[j])
        r += (β[j] - βnew) .* X[:, j]
        β[j] = βnew
      end
    currObj = .5 * norm(y-X*β)^2 + λ * norm(β[2:end], 1)
    iters += 1
  end
  return β
end

### 1c
function lasso_apg(X, y, λ, tol, β = (y \ X)')
  currObj = .001
  prevObj = .001
  p = size(X, 2)
  n = size(X, 1)
  x1 = X[1, 1] # Assumes X[:,1] = x1
  s = 1 / eigmax(X' * X)
  βtm1 = copy(β)
  βtm2 = copy(β)
  r = vec(y - X * β)
  iters = 0
  while abs(currObj - prevObj)/prevObj  > tol || iters == 0
    iters += 1
    prevObj = copy(currObj)
    # Update β_0:
      βnew = β[1] + mean(r) / x1
      r = r .+ ((β[1] - βnew)*x1)
      β[1] = βnew
    # Update β_j's
      Xpr = X' * r
      βextr = βtm1 + (iters-2)/(iters+1) .* (βtm1 - βtm2)
      z = βextr + s .* Xpr
      for j = 2:p
        βnew = softThresh(z[j], λ * s)
        r += (β[j] - βnew) .* X[:, j]
        β[j] = βnew
      end
    βtm1 = deepcopy(β)
    βtm2 = deepcopy(βtm1)
    currObj = .5 * norm(y-X*β)^2 + λ * norm(β[2:end], 1)
  end
  return β
end

# 2
function formH(n, p = n)
  # Default is to return n*n matrix, otherwise n*p portion of H
  H = zeros(n, n)
  H[:, 1] = 1 / sqrt(n)
  for j = 2:n
    for i = 1:(j-1)
      H[i, j] = 1/sqrt(j * (j-1))
    end
    H[j, j] = -(j-1)/sqrt(j * (j-1))
  end
  return H[:, 1:p]
end

p = 1000
n = 10000
X = formH(n, p)
βtrue = zeros(p)
βtrue[1:5] = 1:5
srand(2015790003)
y = X * βtrue + randn(n)

function getAnalyticalSoln(y, p, λ)
  n = size(y,1)
  β = zeros(p)
  for j = 2:p
    ystar = sum(y[1:(j-1)]) - y[j]
    ystar /= sqrt(j*(j-1))
    β[j] = softThresh(ystar, λ)
  end
  β[1] = sum(y) / sqrt(n)
  return β
end

λs = 0:0.6:6
N = length(λs)
βs_convex = zeros(p, N)
βs_cd = zeros(p, N)
βs_apg = zeros(p, N)
βs_Solutions = zeros(p, N)
for i in 1:N
  βs_Solutions[:, i] = getAnalyticalSoln(y, p, λs[i])
end

# Initialize JIT compiler
lasso_convex(X, y, 1);
lasso_cd(X, y, 1, 10e-4);
lasso_apg(X, y, 1, 10e-4);

print("\nConvex solver: \n")
@time for i in 1:N
  βs_convex[:,i] = lasso_convex(X, y, λs[i])
end

print("\nCoordinate descent: \n")
@time for i in N:-1:1
  if i == 11
    βs_cd[:,i] = lasso_cd(X, y, λs[i], 10e-4)
  else
    βs_cd[:,i] = lasso_cd(X, y, λs[i], 10e-4, βs_cd[:,i+1])
  end
end

print("\nAccelerated proximal gradient: \n")
@time for i in N:-1:1
  if i == 11
    βs_apg[:,i] = lasso_apg(X, y, λs[i], 10e-4)
  else
    βs_apg[:,i] = lasso_apg(X, y, λs[i], 10e-4, βs_apg[:,i+1])
  end
end
