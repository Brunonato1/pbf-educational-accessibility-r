# ============================================
# Analysis of PBF Survey Data - PUC-Campinas
# ============================================

# 1) Load packages (equivalent to "import pandas as pd" in Python)
library(tidyverse)  # includes dplyr (data manipulation) and ggplot2 (visualization)
library(readxl)     # Excel reader, equivalent to pd.read_excel()

# 2) Read the spreadsheet
# In Python: df = pd.read_excel("file.xlsx", sheet_name="Base_Dashboard")
data <- read_excel("Base_Questionario_PortfolioDashboard.xlsx",
                   sheet = "Base_Dashboard")

# 3) First look at the data (equivalent to df.head() and df.info())
glimpse(data)   # shows columns, data types, and first few rows
head(data)      # shows the first 6 rows

# 4) Filter for REAL respondents only
# In Python: real_data = data[data['Data_Origin'] == 'Real']
real_data <- data |> filter(Data_Origin == "Real")

# Verify that exactly 6 rows remain
nrow(real_data)  # should return 6

# 5) Simple descriptive statistics: frequency tables
# In Python: real_data['Gender'].value_counts()
real_data |> count(Gender)
real_data |> count(Race_Ethnicity)
real_data |> count(Wants_Higher_Education)

# 6) Cross-tabulation of two variables (contingency table)
# In Python: pd.crosstab(real_data['Wants_Higher_Education'], real_data['Informed_About_Public_Universities'])
cross_tab <- real_data |>
  count(Wants_Higher_Education, Informed_About_Public_Universities)

print(cross_tab)

# 7) Recreate the access funnel (same logic as Power BI, now in code)
funnel <- tibble(
  stage = c("Total real respondents",
            "Aware of public university existence",
            "Want or might want to attend university",
            "Took the ENEM exam",
            "Currently enrolled in university"),
  count = c(
    nrow(real_data),
    sum(real_data$Informed_About_Public_Universities == "Yes", na.rm = TRUE),
    sum(real_data$Wants_Higher_Education %in% c("Yes", "Maybe"), na.rm = TRUE),
    sum(real_data$Took_ENEM == "Yes", na.rm = TRUE),
    sum(real_data$Attending_University == "Yes", na.rm = TRUE)
  )
)

print(funnel)

# 8) Simple bar chart (equivalent to matplotlib/seaborn)
ggplot(funnel, aes(x = reorder(stage, -count), y = count)) +
  geom_col(fill = "#1F3864") +
  labs(title = "Higher Education Access Funnel (N = 6, real data)",
       x = NULL, y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# ============================================
# METHODOLOGICAL NOTE
# With N = 6, these results are exploratory/descriptive
# and should not be interpreted as statistically representative
# or generalizable to the broader population of PBF recipients.
# ============================================

# ============================================
# 9) INFERENTIAL ANALYSIS (Fisher's Exact Test)
# ============================================
cross_tab_fisher <- table(
  real_data$Informed_About_Public_Universities,
  real_data$Wants_Higher_Education
)

fisher_test <- fisher.test(cross_tab_fisher)
print(fisher_test)


# ============================================
# 10) ADVANCED VISUALIZATION (Socioeconomic Cross-Tabulation)
# ============================================
ggplot(real_data, aes(x = Race_Ethnicity, fill = Felt_Prepared_For_ENEM)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("No" = "#C00000", "Yes" = "#2F5597", "Not reported" = "#7F7F7F")) +
  labs(
    title = "Perception of ENEM Preparation by Race/Ethnicity",
    subtitle = "Real PBF Survey Data (N = 6)",
    x = "Race / Ethnicity",
    y = "Number of Respondents",
    fill = "Felt prepared?"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    legend.position = "bottom"
  )
