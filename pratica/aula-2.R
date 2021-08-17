# Substituir NAs das variáveis por algum texto

casas <- readr::read_rds("data/casas.rds")

casas_sem_na <- casas %>% 
  mutate(
    across(
      .cols = where(is.character),
      .fns = tidyr::replace_na,
      replace = "Sem informação"
    )
  )

conta_na <- function(.x) {
  sum(is.na(.x))
}

conta_na(c(1, 2, NA, 3, NA, 10))

casas_sem_na %>% 
  summarise(
    across(
      .cols = where(is.character),
      .fns = conta_na
    )
  ) %>%
  tidyr::pivot_longer(
    cols = everything(),
    names_to = "nome_da_coluna",
    values_to = "num_nas"
  ) %>% 
  filter(num_nas > 0)

# usando notação lambda/função anônima

casas_sem_na %>% 
  summarise(
    across(
      .cols = where(is.character),
      .fns = ~sum(is.na(.x))
    )
  ) %>%
  tidyr::pivot_longer(
    cols = everything(),
    names_to = "nome_da_coluna",
    values_to = "num_nas"
  ) %>% 
  filter(num_nas > 0)


# -------------------------------------------------------------------------

# Fazer o gráfico de disp da var lucro por todas as vars numericas

imdb <- readr::read_rds("data/imdb.rds")
View(imdb)

library(ggplot2)

imdb %>% 
  select(titulo:duracao)

imdb %>%
  mutate(lucro = receita - orcamento) %>% 
  select(where(is.numeric)) %>% 
  tidyr::pivot_longer(
    cols = -lucro,
    names_to = "variavel",
    values_to = "valores"
  ) %>% 
  ggplot() +
  geom_point(aes(x = valores, y = lucro)) +
  facet_wrap(vars(variavel), scales = "free")




