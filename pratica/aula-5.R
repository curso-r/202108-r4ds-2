library(dplyr)
library(tidyr)
library(purrr)
library(stringr)
library(ggplot2)

# Calcular o lucro médio por gênero do filme

imdb <- readr::read_rds("data/imdb.rds")

imdb %>% 
  filter(str_detect(generos, "Action")) %>% 
  mutate(lucro = receita - orcamento) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE))


imdb %>% 
  mutate(generos_separados = str_split(generos, "\\|")) %>% 
  unnest(cols = generos_separados) %>% 
  group_by(generos_separados) %>% 
  summarise(
    lucro_medio = mean(receita - orcamento, na.rm = TRUE)
  )

# é diferente de usar o tidyr::separate
imdb %>% 
  separate(generos, c("g1", "g2", "g3"), "\\|", remove = FALSE) %>% 
  View()


# Gráfico nota_imdb vs orçamento por ano a partir de 1970

fazer_grafico <- function(tab) {
  tab %>% 
    ggplot(aes(x = orcamento, y = nota_imdb)) +
    geom_point()
}

tab_graficos <- imdb %>% 
  filter(ano >= 1970) %>% 
  group_by(ano) %>% 
  nest() %>% 
  mutate(
    grafico = map(data, fazer_grafico)
  )

tab_graficos %>% 
  filter(ano == 2000) %>% 
  pluck("grafico", 1)

tab_graficos %>% 
  filter(ano == 1990) %>% 
  pull(grafico)

p <- ggplot(imdb, aes(x = orcamento, y = receita)) + geom_point()


# Usando o purrr para ler (e empilhar) várias bases de dados

arquivos <- list.files("data/imdb_por_ano/", pattern = "rds$", full.names = TRUE)

ler_arquivo <- function(caminho) {
  
  ano_ <- str_extract(caminho, "[0-9]{4}")
  
  readr::read_rds(caminho) %>% 
    mutate(
      receita = as.numeric(receita),
      ano_extraido_do_arq = as.integer(ano_)
    )
}

purrr::map(
  arquivos,
  ler_arquivo
) %>% 
  bind_rows()

map_dfr(
  arquivos,
  readr::read_rds
)


imdb <- purrr::map_dfr(
  arquivos,
  ler_arquivo
) 

sum(imdb$ano != imdb$ano_extraido_do_arq)



# -------------------------------------------------------------------------

partidas <- readr::read_csv("https://raw.githubusercontent.com/williamorim/brasileirao/master/data-raw/csv/matches.csv")

placar_teste <- "2x0"

gols <- str_split(placar_teste, "x")

gols[[1]][1] > gols[[1]][2]


calcular_pontos <- function(placar) {
  gols <- str_split(placar, "x")
  
  if (gols[[1]][1] > gols[[1]][2]) {
    return(c(3, 0))
  } else if (gols[[1]][1] == gols[[1]][2]) {
    return(c(1, 1))
  } else {
    return(c(0, 3))
  }
  
}

# a função não funciona com vetores
calcular_pontos(c("1x1", "2x1"))


partidas %>% 
  mutate(
    num_pontos = map(score, calcular_pontos)
  ) %>% 
  unnest(cols = num_pontos) %>% 
  View()















