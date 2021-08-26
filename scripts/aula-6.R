library(dplyr)

starwars[starwars$homeworld == "Naboo" & starwars$species == "Human", ,]

homeworld <- starwars$homeworld
species <- starwars$species
starwars[homeworld == "Naboo" & species == "Human", ,]

filter(starwars, homeworld == "Naboo", species == "Human")

# -------------------------------------------------------------------------

starwars %>%
  filter(is.na(birth_year)) %>%
  nrow()

filter_na <- function(df, col) {
  filter(df, is.na(col))
}

starwars %>%
  filter_na(birth_year) %>%
  nrow()

filter_na <- function(df, col) {
  filter(df, is.na( {{ col }} ))
}

starwars %>%
  filter_na(birth_year) %>%
  nrow()

# -------------------------------------------------------------------------

summarise_by <- function(df, by, ...) {
  df %>%
    group_by({{by}}) %>%
    summarise(...)
}

starwars %>%
  summarise_by(
    homeworld,
    media_massa = mean(mass, na.rm = TRUE),
    media_altura = mean(height, na.rm = TRUE)
  )

meu_select <- function(df, ...) {
  select(df, eye_color, ...)
}

starwars %>%
  meu_select(homeworld, mass)

# -------------------------------------------------------------------------

sw1 <- starwars
sw2 <- starwars

summarise_por_planeta <- function(df, ...) {
  df %>%
    group_by(homeworld) %>%
    summarise(...)
}

purrr::map(
  list(sw1, sw2),
  summarise_por_planeta,
  media_massa = mean(mass, na.rm = TRUE),
  media_altura = mean(height, na.rm = TRUE)
)

purrr::map(
  list(sw1, sw2),
  summarise_by,
  by = species,
  media_massa = mean(mass, na.rm = TRUE),
  media_altura = mean(height, na.rm = TRUE)
)

# -------------------------------------------------------------------------

base_misteriosa <- starwars
library(tidyr)

cols_manter <- base_misteriosa %>%
  summarise(across(.fns = ~sum(is.na(.x)))) %>%
  pivot_longer(everything(), names_to = "cols", values_to = "nas") %>%
  filter(nas <= 10) %>%
  pull(cols)

for (col_interesse in cols_manter) {

  base_misteriosa %>%
    summarise({{col_interesse}} := sum(!is.na(.data[[col_interesse]]))) %>%
    print()

}
