# Product 1: risk-neutral stock price distribution at maturity via a CRR binomial tree.
# Earlier draft of binomial_tree.R, using the 9 December 2024 market snapshot and the
# 52-week US Treasury Bill coupon-equivalent rate (4.19%) instead of the bank-discount
# rate (4.04%) used in the final report.

# Parameters
r <- 0.0419    # annual risk-free rate
sigma <- 0.1405 # annual volatility
S0 <- 298.98    # current stock price
T <- 1.104      # total time in years (from 2024-12-09 to 2026-01-16)
n <- 4         # number of steps

# Compute step size
dt <- T / n

# Compute up and down factors using CRR model
u <- exp(sigma * sqrt(dt))
d <- 1/u

# Compute risk-neutral probability
p <- (exp(r * dt) - d) / (u - d)

# Initialize price tree as a matrix
# Rows represent time steps, columns represent different nodes at that step
# At step i, there are (i+1) possible nodes
S <- matrix(0, nrow = n+1, ncol = n+1)
S[1,1] <- S0  # at time 0, only one node: S0

# Fill the binomial tree
for(i in 1:n) {
  for(j in 1:(i+1)) {
    # j runs from 1 to (i+1), representing how many down moves occurred
    # i-j represents number of up moves
    up_moves <- i - (j-1)
    down_moves <- j-1
    S[i+1,j] <- S0 * (u^up_moves) * (d^down_moves)
  }
}

# Now S[n+1, ] contains all possible stock prices at maturity
# The probabilities for each node at maturity (risk-neutral) can be computed as:
# P(k down moves out of n) = C(n, k) * p^(n-k) * (1-p)^k
# where k = 0,1,...,n
# k corresponds to j-1 in our indexing

# Compute probabilities at maturity
final_prices <- S[n+1, 1:(n+1)]
final_probs <- numeric(n+1)

for(j in 1:(n+1)) {
  k <- j-1  # number of down moves
  # binomial coefficient
  comb <- choose(n, k)
  final_probs[j] <- comb * p^(n - k) * (1 - p)^k
}

# Check that probabilities sum to 1
prob_sum <- sum(final_probs) # should be very close to 1

# Print results
cat("Up factor (u):", u, "\n")
cat("Down factor (d):", d, "\n")
cat("Risk-neutral probability (p):", p, "\n")
cat("Sum of probabilities:", prob_sum, "\n")

cat("\nFinal stock price distribution at T:\n")
result <- data.frame(Price=final_prices, Probability=final_probs)
print(result)
library(openxlsx)
write.xlsx(result, file = "data/crr_tree_result.xlsx", sheetName = "FinalPrices", overwrite = TRUE)
