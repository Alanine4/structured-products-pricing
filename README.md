# Structured products pricing on McDonald's stock

Design and pricing of two structured products on McDonald's Corporation (MCD) stock: a partially principal protected note and an ATM digital, both maturing 16 January 2026. The underlying stock price and option quotes come from Yahoo Finance, and the products are priced with a CRR binomial tree and the Black-Scholes formula, written in R (with a supporting MATLAB exercise from the same coursework).

Coursework project for Fundamentals of Financial Mathematics, Master of Actuarial and Financial Engineering, KU Leuven (2024). The full write-up is in [`report/Structured_Products_Pricing_Report.pdf`](report/Structured_Products_Pricing_Report.pdf).

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

**Stock price distribution (Product 1).** `R/binomial_tree.R` builds a 4-step Cox-Ross-Rubinstein binomial tree for MCD over the life of the note and reads off the risk-neutral distribution of ST. `R/crr_tree.R` is an earlier version of the same tree: it uses the 9 December 2024 market snapshot and the 52-week US Treasury Bill rate quoted on a coupon-equivalent basis (4.19%), while the final report uses a 11 December 2024 snapshot and the bank-discount quote (4.04%). Both scripts are included as submitted; `binomial_tree.R` is the one whose numbers match the final report.

**Digital call price (Product 2).** `R/black_scholes_digital.R` prices the ATM digital call in closed form, discounting the risk-neutral probability that ST ends at or above the strike. The report cross-checks this against a market-based approximation: a narrow call spread around the strike, built from quoted MCD call prices at K=300 and K=305.

**Collar and multiplier scenarios.** `data/structured_products_calculations.xlsx` (sheets Q1 and Q2) takes the tree distribution and the digital call price as inputs and works out, for each collar or multiplier choice, the expected investor payoff and the bank's profit margin.

`matlab/exercises.m` and `matlab/exp_value.m` are introductory MATLAB warm-up exercises from the same course; they do not price either product.

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
  binomial_tree.R              CRR tree for Product 1, final version (matches the report)
  crr_tree.R                   earlier version of the tree, different market snapshot and rate convention
  black_scholes_digital.R       closed-form price of the Product 2 digital call
matlab/
  exercises.m                  introductory MATLAB exercises (unrelated to the two products)
  exp_value.m                  helper function used by exercises.m
data/
  binomial_tree_result.xlsx     output of binomial_tree.R
  crr_tree_result.xlsx          output of crr_tree.R
  structured_products_calculations.xlsx   collar/multiplier scenarios, expected payoffs and margins
report/                        full project report (PDF)
```

## Running the code

Requires R with the `openxlsx` package.

```r
source("R/binomial_tree.R")           # stock price distribution for Product 1
source("R/crr_tree.R")                # earlier version, kept for reference
source("R/black_scholes_digital.R")   # digital call price for Product 2
```

Each script prints its results to the console and, for the two tree scripts, writes them to an xlsx file under `data/`. Run them from the repository root so the output paths resolve correctly.

`matlab/exercises.m` and `matlab/exp_value.m` only use base MATLAB (matrix indexing, `rand`, `eye`, loops, `disp`) and need no toolbox. They were not run for this repository: MATLAB was not available in the packaging environment, so the files are included as submitted, cleaned up for formatting only.

Market quotes (MCD spot price, option prices and implied volatility from Yahoo Finance, the Treasury Bill rate from home.treasury.gov) are entered directly in the R scripts and the Excel workbook, as of the dates stated above.
