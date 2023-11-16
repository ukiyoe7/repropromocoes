## VIEW CLIENTES

library(DBI)
library(dplyr)
library(readr)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")


cli <- dbGetQuery(con2, statement = read_file('CLIENTES.sql'))

View(cli)

inativos <- dbGetQuery(con2, statement = read_file('INATIVOS.sql'))

View(inativos)

clien <- anti_join(cli,inativos,by="CLICODIGO") 

View(clien)