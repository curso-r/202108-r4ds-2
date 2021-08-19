library(lubridate)

# Output
format.Date(now(), "%d/%m/%Y %H:%M:%S")

# Conversão para SP (com horário de verão!)
with_tz(dmy_hms("15/02/2019 02:25:00"), tzone = "America/Sao_Paulo")
with_tz(dmy_hms("15/02/2020 02:25:00"), tzone = "America/Sao_Paulo")

# Arrendondar
floor_date(today(), unit = "month") # Função chão
rollforward(today())                # Fim do mês

# Feriados (usar o pacote bizdays)
bizdays::add.bizdays("2020-12-30", 5, cal = "Brazil/ANBIMA")
