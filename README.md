# Structured products pricing on McDonald's stock

Design and pricing of two structured products on McDonald's Corporation (MCD) stock: a partially principal protected note and an ATM digital, both maturing 16 January 2026. The underlying stock price and option quotes come from Yahoo Finance, and the products are priced with a CRR binomial tree and the Black-Scholes formula, written in R.

The full write-up is in [`report/Structured_Products_Pricing_Report.pdf`](report/Structured_Products_Pricing_Report.pdf).

## The products

**Product 1: partially principal protected note (PPPN).** For an investment N, the investor is guaranteed 90% of N at maturity plus a premium that depends on the stock price at maturity, ST, relative to two strikes K1 and K2:

```
premium = N/S0 * (K1 - ST)   if ST < K1
premium = 0                  if K1 <= ST <= K2
premium = N/S0 * (ST - K2)   if ST > K2
```

The report checks three collars, (K1, K2) = (280, 305), (290, 310) and (295, 315), priced against real MCD put and call quotes.

**Product 2: ATM digital.** For an investment N, the investor gets the full notional back at maturity, plus a bonus m*N if the stock closes at or above its starting level S0:

```
payoff = N + m*N   if ST >= S0
payoff = N          if ST < S0
```

The bonus multiplier m is set from the price of a digital (cash-or-nothing) call struck at S0. The report works out the break-even m (the point where the bank makes no margin) and then several lower values of m that leave the bank a profit.

## Method

**Stock price distribution (Product 1).** `R/binomial_tree.R` builds a 4-step Cox-Ross-Rubinstein binomial tree for MCD over the life of the note and reads off the risk-neutral distribution of ST.

**Digital call price (Product 2).** `R/black_scholes_digital.R` prices the ATM digital call in closed form, discounting the risk-neutral probability that ST ends at or above the strike. The report cross-checks this against a market-based approximation: a narrow call spread around the strike, built from quoted MCD call prices at K=300 and K=305.

**Collar and multiplier scenarios.** `data/structured_products_calculations.xlsx` (sheets Q1 and Q2) takes the tree distribution and the digital call price as inputs and works out, for each collar or multiplier choice, the expected investor payoff and the bank's profit margin.

## Results

Risk-neutral distribution of the MCD stock price at maturity (`binomial_tree.R`):

| ST | Probability |
|---|---|
| 377.70 | 0.114 |
| 336.04 | 0.329 |
| 298.98 | 0.356 |
| 266.00 | 0.171 |
| 236.66 | 0.031 |

Digital call price (`black_scholes_digital.R`, ATM, T = 1.09 years): 0.599, rounded to 0.6 in the report and matched by the tight-call-spread check against market quotes.

Product 1, expected payoff and bank margin per collar (from the Excel workbook, N = 100):

| Collar | Expected payoff | Bank margin |
|---|---|---|
| K1 = 280, K2 = 305 | 101.02 | 0.53 |
| K1 = 290, K2 = 310 | 100.23 | 0.86 |
| K1 = 295, K2 = 315 | 99.83 | 0.94 |

Product 2, expected payoff and bank margin per multiplier (N = 100):

| m | Expected payoff | Bank margin |
|---|---|---|
| 0.08 (break-even) | 103.32 | 0.00 |
| 0.07 | 103.10 | 0.30 |
| 0.06 | 102.65 | 0.89 |
| 0.05 | 102.21 | 1.48 |
| 0.04 | 101.77 | 2.07 |

## Repository layout

```
R/
  binomial_tree.R              CRR tree for Product 1
  black_scholes_digital.R       closed-form price of the Product 2 digital call
data/
  binomial_tree_result.xlsx     output of binomial_tree.R
  structured_products_calculations.xlsx   collar/multiplier scenarios, expected payoffs and margins
report/                        full project report (PDF)
```

## Running the code

Requires R with the `openxlsx` package.

```r
source("R/binomial_tree.R")           # stock price distribution for Product 1
source("R/black_scholes_digital.R")   # digital call price for Product 2
```

Each script prints its results to the console and the tree script also writes them to an xlsx file under `data/`. Run them from the repository root so the output paths resolve correctly.

Market quotes (MCD spot price, option prices and implied volatility from Yahoo Finance, the Treasury Bill rate from home.treasury.gov) are entered directly in the R scripts and the Excel workbook.
