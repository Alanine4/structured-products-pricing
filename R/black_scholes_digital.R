# Product 2: ATM digital call, priced with the Black-Scholes closed form.

# Parameters
S0 <- 301.76    # Current underlying price
K <- S0          # Strike price equal to S0 (ATM)
r <- 0.0404      # Annual risk-free interest rate
sigma <- 0.1115  # Annual volatility
T <- 1.09         # Time to maturity in years
q <- 0           # Dividend yield (0 if none)

# For a digital (cash-or-nothing) call paying $1 if ST >= K:
# The Black-Scholes formula for a digital call (without dividends) is:
# Digital Call Price = e^{-rT} * Phi(d2)
#
# where:
# d2 = [ln(S0/K) + (r - sigma^2/2)*T] / (sigma * sqrt(T))
#
# Since K = S0, ln(S0/K) = ln(1) = 0, simplifying:
# d2 = [(r - sigma^2/2)*T] / (sigma*sqrt(T))

d2 <- ((r - 0.5*sigma^2)*T) / (sigma*sqrt(T))

# Phi(d2) is the cumulative distribution function (CDF) of the standard normal distribution at d2.
phi_d2 <- pnorm(d2)

# Digital call price = e^{-rT} * Phi(d2)
digital_call_price <- exp(-r*T)*phi_d2

cat("Theoretical price of the ATM digital call (paying 1 USD if ST >= K):", digital_call_price, "\n")
