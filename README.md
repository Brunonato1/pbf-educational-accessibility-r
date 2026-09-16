# Public Policy & Educational Accessibility Analysis (R / Tidyverse)

## Overview
This repository contains a quantitative data processing pipeline and exploratory analysis of primary survey data regarding educational access barriers for social benefit recipients (*Bolsa Família* [PBF]). The project demonstrates reproducible data manipulation, non-parametric inferential statistics, and publication-ready data visualization in R.

### Research Title & Context
- **Research Title:** *Trajetórias escolares dos beneficiários do Programa Bolsa Família egressos do ensino médio das escolas públicas estaduais do município de Amparo (SP)*.
- **Bolsa Família Program (PBF) Focus:** The study investigates the impact of PBF educational conditionalities—specifically mandatory school attendance—on secondary school completion among low-income students in Amparo (SP). It explores how the PBF provides immediate poverty relief while examining the structural limits of conditional cash transfers when youth face the financial necessity of entering the labor market, impacting their transitions to higher education and ex-post social mobility[cite: 2].

## Methodological Architecture
- **Data Wrangling & Cleaning:** Ingestion of relational survey data via `readxl` and data transformation using `tidyverse` (`dplyr`).
- **Descriptive Funnel Analysis:** Structured an educational progression metric tracking students from secondary completion to higher education enrolment.
- **Inferential Statistics:** Applied **Fisher's Exact Test** (`fisher.test`) to evaluate independence between categorical variables under small-sample pilot conditions ($N = 6$), adhering to statistical assumptions where expected frequencies are below 5.
- **Data Visualization:** Built customized bivariate plots using `ggplot2`.

## Key Outputs
1. **Educational Access Funnel:** Identifies structural drop-off points along the educational path.
2. **Fisher's Exact Test:** Evaluates association between information access and higher education aspirations.
3. **Bivariate Visualizations:** Cross-examines race/ethnicity against perceptions of exam preparation.

## Repository Structure
- `analise (1).R`: Core R script containing data pipeline, statistical tests, and plot rendering.
- `Base_Questionario_PortfolioDashboard.xlsx`: Anonymized primary survey dataset.
- `figures/`: High-resolution graphics generated from the analysis.
