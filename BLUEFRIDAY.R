library(DBI)
library(tidyverse)
library(readr)
library(googledrive)

con2 <- dbConnect(odbc::odbc(), "repro",encoding="Latin1")


## CLIENTES DA PROMO SEM OS GRUPOS 320 3 32
clien_promo_blue_friday <-
 clien %>% filter(GCLCODIGO!=320 | is.na(GCLCODIGO)) %>% filter(GCLCODIGO!=32 | is.na(GCLCODIGO))


View(clien_promo_blue_friday)



# GERA TABELAS

ferri <-
dbGetQuery(con2,"SELECT CLICODIGO FROM CLIEN WHERE GCLCODIGO IN (320,32) ") 


clien_promo_blue_friday_relrepro <-
dbGetQuery(con2,"SELECT * FROM CLITBP WHERE TBPCODIGO=102 AND TBPDESC2 IS NOT NULL") 

View(clien_promo_blue_friday_relrepro)

clien_promo_blue_friday_relrepro2 <-
  anti_join(clien_promo_blue_friday_relrepro,ferri,by="CLICODIGO")

View(clien_promo_blue_friday_relrepro2)


write.csv2(clien_promo_blue_friday_relrepro2,file = "C:\\Users\\REPRO SANDRO\\Documents\\PROMOÇÕES\\2023\\NOV\\clien_promo_blue_friday_relrepro2.csv", row.names = FALSE,na="")



dbGetQuery(con2,"SELECT TBPCODIGO FROM TABPRECO") %>% 
  write.csv2(.,file = "C:\\Users\\REPRO SANDRO\\Documents\\PROMOÇÕES\\2023\\NOV\\tabpreco.csv", row.names = FALSE,na="")


sequence <- seq(1855, by = 1, length.out = 1700)
data_frame <- data.frame(TBPCODIGO = sequence)

anti_join(data_frame,dbGetQuery(con2,"SELECT TBPCODIGO FROM TABPRECO"),by="TBPCODIGO") %>% 
  
  write.csv2(.,file = "C:\\Users\\REPRO SANDRO\\Documents\\PROMOÇÕES\\2023\\NOV\\tabpreco.csv", row.names = FALSE,na="")


## BIND TABPROMO CLI RELREPRO


tab_promo_relrepro_blufriday_clirelrepro <-
cbind(
dbGetQuery(con2,"SELECT * FROM TABPRECO WHERE TBPDESCRICAO LIKE '%BLUE FRIDAY - UPGRADE XR%' AND TBPCODIGO<>1851") ,
clien_promo_blue_friday_relrepro2) 


## INSERT TAB 1851 CLI SEM RELPRO

clien_promo_blue_friday_sem_relrepro <-
anti_join(clien_promo_blue_friday,clien_promo_blue_friday_relrepro2,by="CLICODIGO")


View(clien_promo_blue_friday_sem_relrepro)

clien_promo_blue_friday_sem_relrepro %>% select(CLICODIGO) %>% 
write.csv2(.,file = "C:\\Users\\REPRO SANDRO\\Documents\\PROMOÇÕES\\2023\\NOV\\clien_promo_blue_friday_sem_relrepro.csv", row.names = FALSE,na="")

## CROSS JOIN TABPROMO 

tbcomb_bluefriday <- 
dbGetQuery(con2,"SELECT * FROM TBPCOMBPROPRO WHERE TBPCODIGO=1851") 


merge(tbcomb_bluefriday,clien_promo_blue_friday_relrepro2,by=NULL) %>% View()








