
minha_f <- function(arg) {
  arg + 1
}

minha_f <- function(arg) { arg + 1 }

minha_f <- function(arg) arg + 1

minha_f <- \(arg) arg + 1

minha_f <- \(.x) .x + 1

# Não funciona
minha_f <- ~ .x + 1

.fns = ~ .x + 1

# Slide
~sum(is.na(.x))

\(.x) sum(is.na(.x))

\(arg) sum(is.na(arg))

function(arg) sum(is.na(arg))

function(arg) { sum(is.na(arg)) }

function(arg) {
  sum(is.na(arg))
}

library(dplyr)

dados::casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols  = c(lote_area, venda_valor), # Variáveis
    .fns   = mean, na.rm = TRUE,        # Função
    .names = "{.col}_media"             # Nomes
  ))

dados::casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),                  # Variáveis
    .fns  = list(distintos = n_distinct, media = mean), # Função
    .names = "{.col}_{.fn}"                             # Nomes
  )) %>%
  glimpse()

# id x y z
# 1  a c e
# 2  b d f
#
# id antigas_colunas antigos_valores
# 1  x               a
# 2  x               b
# 1  y               c
# 2  y               d
# 1  z               e
# 2  z               f
