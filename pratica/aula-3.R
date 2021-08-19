library(dplyr)
library(stringr)

### scrape ####
url <- "https://en.wikipedia.org/wiki/List_of_Rick_and_Morty_episodes"

res <- httr::GET(url)

wiki_page <- httr::content(res)

lista_tab <- wiki_page %>%
  xml2::xml_find_all(".//table") %>%
  magrittr::extract(2:5) %>%
  rvest::html_table(fill = TRUE) %>%
  purrr::map(janitor::clean_names) %>%
  purrr::map(~dplyr::rename_with(.x, ~stringr::str_remove(.x, "_37")))

num_temporadas <- 1:length(lista_tab)

tab <- lista_tab %>%
  purrr::map2(num_temporadas, ~dplyr::mutate(.x, no_season = .y)) %>%
  dplyr::bind_rows()
################

tab %>% 
  mutate(
    original_air_date = ifelse(
      is.na(original_air_date),
      original_air_date_38,
      original_air_date
    )
  ) %>% 
  select(-original_air_date_38) %>%
  mutate(
    #pegar o que tá entre parênteses com regex e aplicar ymd
    original_air_date = str_extract(original_air_date, "[(0-9)-]*$"),
    original_air_date = str_remove_all(original_air_date, "[()]"),
    original_air_date = lubridate::ymd(original_air_date)
  ) %>% 
  mutate(
    u_s_viewers_millions = str_remove_all(
      u_s_viewers_millions, 
      "\\[[0-9a-z]*\\]"
    ),
    u_s_viewers_millions = as.numeric(u_s_viewers_millions)
  ) %>% 
  View()

#ou da pra ir direto no lubridate?

# playground

ifelse(10 > 15, "a", "b")

str_extract("December 2, 2013 (2013-12-02)", "[(0-9)-]*$")
str_extract("December 2, 2013 (2013-12-02)", "[0-9]{4}-[0-9]{2}-[0-9]+")
str_sub("December 2, 2013 (2013-12-02)", -11, -2)


str_remove("1.84[25]", "\\[[0-9]*\\]")

str_remove_all("0.68[26][ab]", "\\[[:alnum:]*\\]")





