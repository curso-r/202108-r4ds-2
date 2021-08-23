l <- list(
  um_numero = 123,
  um_vetor = c(TRUE, FALSE, TRUE),
  uma_string = "abc",
  uma_lista = list(1, 2, 3)
)

d <- tibble::tibble(
  col_numero = 123,
  col_logica = TRUE,
  col_string = "abc"
)

d$col_numero == d[[1]] == d[["col_numero"]]
l$um_numero  == l[[1]] == l[["um_numero"]]

d["col_numero"] == d[1] # d[,1]
l["um_numero"]  == l[1]

rua <- list(
  casa1 = "caio",
  casa2 = "william",
  casa3 = c("julio", "athos", "fernando", "daniel"),
  casa4 = list("bea", casaB = c("barbie", "ken"))
)

# Acessa posição
rua[1]
rua["casa1"]
rua[2]
rua[3]
rua[4]

# Acessa elemento
rua[[1]]
rua[["casa1"]]
rua$casa1
rua[[2]]
rua[[3]]
rua[[4]]

# Acessando Barbie
rua$casa4$casaB
rua[4][[1]]
rua[["casa4"]][["casaB"]][[1]] # Correta
rua[[4]][["casaB"]][[1]] # Correta
rua[4][1]
rua[[4]][[2]][[1]] # Correta
rua$casa4$casaB[1] # Correta
rua[4][[2]]

# Com o pluck
library(purrr)
pluck(rua, "casa4", "casaB", 1)
pluck(rua, 4, "casaB", 1)
pluck(rua, 4, 2, 1)
pluck(rua, "casa4", "casaB", 1)
