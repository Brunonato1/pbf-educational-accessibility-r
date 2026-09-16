# ============================================
# Análise dos dados da pesquisa PBF - PUC-Campinas
# ============================================

# 1) Carregar os pacotes (igual "import pandas as pd" no Python)
library(tidyverse)  # inclui dplyr (manipulação) e ggplot2 (gráficos)
library(readxl)      # leitor de Excel, igual pd.read_excel()

# 2) Ler a planilha
# Em Python seria: df = pd.read_excel("arquivo.xlsx", sheet_name="Base_Dashboard")
dados <- read_excel("Base_Questionario_PortfolioDashboard.xlsx",
                     sheet = "Base_Dashboard")

# 3) Dar uma primeira olhada nos dados (igual df.head() e df.info())
glimpse(dados)   # mostra colunas, tipos e primeiras linhas
head(dados)      # mostra as 6 primeiras linhas

# 4) Filtrar só os respondentes REAIS
# Em Python seria: dados_reais = dados[dados['Origem_do_dado'] == 'Real']
dados_reais <- dados |> filter(Origem_do_dado == "Real")

# Conferir se ficaram só 6 linhas
nrow(dados_reais)  # deve mostrar 6

# 5) Estatística descritiva simples: frequências
# Em Python seria: dados_reais['Gênero'].value_counts()
dados_reais |> count(Gênero)
dados_reais |> count(cor)
dados_reais |> count(quer_fazer_faculdade)

# 6) Cruzamento de duas variáveis (tabela de contingência)
# Em Python seria: pd.crosstab(dados_reais['quer_fazer_faculdade'], dados_reais['informado_sobre_existencia_de_universidade_publica'])
tabela_cruzada <- dados_reais |>
  count(quer_fazer_faculdade, informado_sobre_existencia_de_universidade_publica)

print(tabela_cruzada)

# 7) Recriar o funil de acesso (mesma lógica do Power BI, agora em código)
funil <- tibble(
  etapa = c("Total de respondentes reais",
            "Sabem que existe universidade pública",
            "Querem ou talvez queiram fazer faculdade",
            "Fizeram o ENEM",
            "Estão cursando faculdade"),
  quantidade = c(
    nrow(dados_reais),
    sum(dados_reais$informado_sobre_existencia_de_universidade_publica == "Sim", na.rm = TRUE),
    sum(dados_reais$quer_fazer_faculdade %in% c("Sim", "Talvez"), na.rm = TRUE),
    sum(dados_reais$fez_enem == "Sim", na.rm = TRUE),
    sum(dados_reais$faz_faculdade == "Sim", na.rm = TRUE)
  )
)

print(funil)

# 8) Um gráfico de barras simples (equivalente ao matplotlib/seaborn)
ggplot(funil, aes(x = reorder(etapa, -quantidade), y = quantidade)) +
  geom_col(fill = "#1F3864") +
  labs(title = "Funil de Acesso à Universidade (N = 6, dados reais)",
       x = NULL, y = "Quantidade") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))

# ============================================
# NOTA METODOLÓGICA
# Com N = 6, estes resultados são exploratórios/descritivos,
# não devem ser interpretados como estatisticamente representativos
# ou generalizáveis para a população de beneficiários do PBF.
# ============================================
# ============================================
# 9) ANÁLISE INFERENCIAL (Teste Exato de Fisher)
# ============================================
tabela_cruzada_fisher <- table(
  dados_reais$informado_sobre_existencia_de_universidade_publica,
  dados_reais$quer_fazer_faculdade
)

teste_fisher <- fisher.test(tabela_cruzada_fisher)
print(teste_fisher)


# ============================================
# 10) VISUALIZAÇÃO AVANÇADA (Cruzamento Socioeconômico)
# ============================================
ggplot(dados_reais, aes(x = cor, fill = sentiuse_preparado_para_enem)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Não" = "#C00000", "Sim" = "#2F5597", "Não informado" = "#7F7F7F")) +
  labs(
    title = "Percepção de Preparação para o ENEM por Cor/Raça",
    subtitle = "Dados Reais da Pesquisa PBF (N = 6)",
    x = "Cor / Raça",
    y = "Quantidade de Respondentes",
    fill = "Sentiu-se preparado?"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    legend.position = "bottom"
  )
