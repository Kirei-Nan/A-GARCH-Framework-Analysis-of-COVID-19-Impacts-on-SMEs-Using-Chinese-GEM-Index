
# GARCH Analysis of COVID-19 Impact on SMEs

## Overview
This repository accompanies the paper "A GARCH Framework Analysis of COVID-19 Impacts on SMEs Using Chinese GEM Index," which utilizes the GARCH model to analyze the effect of COVID-19 on the stock market volatility of SMEs in China, focusing on the Chinese GEM Index.

## Contents
- `code/`: Contains R scripts to perform GARCH model analysis.
  - `gatchyt.R`: Demonstrates GARCH modeling using Apple Inc. stock data as an example.
  - `gatchyt2.R`: Applies similar analysis techniques to Shanghai Stock Exchange Composite Index data.
  - `gatchytoriginal.R`: Analyzes Apple Inc. stock data over a specified period (2008-2019) using various GARCH models.
- `paper/`: A PDF of the research paper.
- `results/`: Visual results from the code.

## Prerequisites
Ensure R is installed with the following libraries:
- `quantmod`
- `xts`
- `PerformanceAnalytics`
- `rugarch`
- `forecast` (for `gatchyt2.R`)

## How to Use
1. **Setup**: Install all required R packages.
2. **Running the Scripts**:
   - `gatchyt.R` and `gatchytoriginal.R` use Apple Inc. stock data for GARCH modeling, including volatility visualization, fitting different GARCH models, and forecasting.
   - `gatchyt2.R` performs a similar analysis but on the Shanghai Stock Exchange Composite Index data.
   - Adapt the scripts for other datasets by modifying the `getSymbols` call or the `read.table` path as needed.
3. **Results**: Check the `results/` directory for the output images that illustrate the analysis.

## Data Adaptation
Replace the stock symbol in the `getSymbols` function or update the CSV file path in `read.table` for your dataset.

## Paper Summary
The paper studies the GEM Index's volatility changes during the COVID-19 pandemic, revealing increased market volatility impacting SMEs. A GARCH model framework is used for simulation and analysis of stock market behaviors to understand the pandemic's economic effects on Chinese SMEs.

## Citation
If you utilize this analysis, please cite the paper as follows:
```
Xuanyu Pan, Zeyu Guo, Zhenghan Nan, Sangeet Srivastava. A GARCH Framework Analysis of COVID-19 Impacts on SMEs Using Chinese GEM Index.
```
