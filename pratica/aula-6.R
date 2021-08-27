# 2. Use a função map() para testar se cada elemento do vetor letters é uma 
# vogal ou não. Dica: você precisará criar uma função para testar se é uma 
# letra é vogal. Faça o resultado ser (a) uma lista de TRUE/FALSE e (b) um vetor
# de TRUE/FALSE.

library(purrr)

res <- map_lgl(letters, ~ .x == "a")
class(res)
res


# 5. Utilize a função walk para salvar cada ano da base imdb em um arquivo 
# .rds diferente, isto é, o arquivo imdb_2001.rds, por exemplo, 
# deve conter apenas filmes do ano de 2001.

imdb <- readr::read_rds("data/imdb.rds")

anos <- imdb %>% 
  dplyr::distinct(ano) %>% 
  tidyr::drop_na(ano) %>% 
  dplyr::pull(ano) %>% 
  sort()

escrever_arq <- function(tab, ano_) {
  tab %>% 
    dplyr::filter(ano == ano_) %>% 
    readr::write_rds(glue::glue("imdb_por_ano/imdb_{ano_}.rds"))
  print(glue::glue("Estou escrevendo a base do ano {ano_}"))
}

walk(
  anos,
  escrever_arq,
  tab = imdb
)


# -------------------------------------------------------------------------

# Fazer uma função que devolve um gráfico de dispersão para qualquer
# tabela e colunas

library(ggplot2)
library(dplyr)

imdb <- readr::read_rds("data/imdb.rds")

# A função recebe strings com o nome das colunas
fazer_gg_dispersao <- function(tab, colx, coly) {
  tab %>% 
    ggplot(aes(x = .data[[colx]], y = .data[[coly]])) +
    geom_point()
}

fazer_gg_dispersao(imdb, colx = "duracao", coly = "nota_imdb")


# A função recebe diretamente o nome das colunas
fazer_gg_dispersao <- function(tab, colx, coly) {
  tab %>% 
    ggplot(aes(x = {{colx}}, y = {{coly}})) +
    geom_point()
}

fazer_gg_dispersao(imdb, colx = duracao, coly = nota_imdb)

# colocando um tema no gráfico

meu_tema <- function() {
  theme(
    panel.background = element_rect(
      fill = "purple"
    )
  )
}

fazer_gg_dispersao(imdb, colx = duracao, coly = nota_imdb) +
  meu_tema()

fazer_gg_dispersao <- function(tab, colx, coly) {
  tab %>% 
    ggplot(aes(x = {{colx}}, y = {{coly}})) +
    geom_point() +
    meu_tema()
}

fazer_gg_dispersao(imdb, colx = receita, coly = nota_imdb)

# passando argumentos como lista

# com o nome da coluna direto fica complexo
fazer_gg_dispersao <- function(tab, colx_coly) {
  colx_coly <- rlang::enexpr(colx_coly)
  
  colx = colx_coly[[2]]
  coly = colx_coly[[3]]
  
  tab %>%
    ggplot(aes(x = {{colx}}, y = {{coly}})) +
    geom_point()
}

fazer_gg_dispersao(mtcars, list(mpg, cyl))



fazer_gg_dispersao <- function(tab, colunas) {
  tab %>% 
    ggplot(aes(x = .data[[colunas[[1]]]], y = .data[[colunas[[2]]]])) +
    geom_point() +
    meu_tema()
}

fazer_gg_dispersao(imdb, colunas = list("receita", "nota_imdb"))

# Vamos fazer vários gráficos utilizando a nossa função

fazer_gg_dispersao <- function(tab, colx, coly) {
  tab %>% 
    ggplot(aes(x = .data[[colx]], y = .data[[coly]])) +
    geom_point()
}

fazer_gg_dispersao(imdb, colx = "duracao", coly = "nota_imdb")

colunasy <- "mpg"
colunasx <- names(mtcars)[names(mtcars) != "mpg"]
colunasx <- mtcars %>% 
  select(-mpg) %>% 
  names()

purrr::map(colunasx, fazer_gg_dispersao, tab = mtcars, coly = colunasy)


# dúvida Denis

fazer_gg_dispersao <- function(tab, colx, coly) {
  tab %>%
    ggplot() +
    geom_point(aes(x = .data[[colx]], y = .data[[coly]])) +
    geom_vline(aes(xintercept = max(.data[[colx]])),
               linetype = "dashed",
               color = "red")
}


fazer_gg_dispersao(mtcars, "wt", "mpg")

max(mtcars$wt)

# dúvida do euler

# O mesmo gráfico  

p <- mtcars %>% 
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  xlab('') +
  ylab('')

tema2 <- function() {
  # ggthemes::scale_colour_wsj("colors6", "") +
  #   ggthemes::theme_wsj(color = "blue") +
    theme(text = element_text(size=18),
          legend.position="bottom")
}

tema2(p)

mtcars %>% 
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  xlab('') +
  ylab('') + 
  tema2()


