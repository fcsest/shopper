library(dplyr)
library(xml2)
library(httr)
library(stringr)
library(abjutils)

shops_1 <- "https://www.sefaz.rs.gov.br/ASP/AAE_ROOT/NFE/SAT-WEB-NFE-NFC_QRCODE_1.asp?p=43201207718633001584650030002668111639294870|2|1|1|D9BFFC0C32DCFF0D80636337B5DBF648EE144E3C" %>%
  GET() %>%
  content('text', encoding = 'latin1') %>%
  read_html() %>%
  xml_find_all(xpath = '//*[@id="respostaWS"]') %>%
  xml_table(fill = T) %>%
  as.data.frame() %>%
  select(X1:X6) %>%
  filter(str_detect(X1,
                    "^[0-9]+"),
         !is.na(X2)) %>%
  rename_with(~c("Código",
                 "Produto",
                 "Quantidade",
                 "Medida",
                 "Valor Unidade",
                 "Valor Total")) %>%
  mutate(Quantidade = ifelse(str_detect(Produto,
                                 "[0-9]+(?=(?i)(kg|g|l|ml| un))"),
                      str_extract(Produto,
                                  "[0-9]+(?=(?i)(kg|g|l|ml| un))") %>%
                        str_squish() %>%
                        as.numeric() %>%
                        "*"(as.numeric(Quantidade)),
                      Quantidade),
         Medida = ifelse(str_detect(Produto,
                                 "[0-9]+(?=(?i)(kg|g|l|ml| un))"),
                      str_extract(Produto,
                                  "(?<=[0-9])(?i)(kg|g|l|ml| un)") %>%
                        str_squish() %>%
                        str_replace("UN", "UNIDADE") %>%
                        str_to_lower(),
                      Medida %>%
                        str_squish() %>%
                        str_replace("UN", "UNIDADE") %>%
                        str_to_lower()),
         Produto_n = Produto %>%
           str_to_lower(locale = "br") %>%
           str_squish() %>%
           str_remove_all("([0-9]+(?i)( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/))|(c/[0-9]+ un)|( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/)$|( b )"))









nota_2 <- "https://www.sefaz.rs.gov.br/ASP/AAE_ROOT/NFE/SAT-WEB-NFE-NFC_QRCODE_1.asp?p=43201207718633001584650080005758491844593480|2|1|1|61ED3FBFB8AADCB65D8B0F1B6F34C802FC20F355"

shops_2 <- nota_2 %>%
  GET() %>%
  content('text', encoding = 'latin1') %>%
  read_html() %>%
  xml_find_all(xpath = '//*[@id="respostaWS"]') %>%
  xml_table(fill = T) %>%
  as.data.frame() %>%
  select(X1:X6) %>%
  filter(str_detect(X1,
                    "^[0-9]+"),
         !is.na(X2)) %>%
  rename_with(~c("Código",
                 "Produto",
                 "Quantidade",
                 "Medida",
                 "Valor Unidade",
                 "Valor Total")) %>%
  mutate(Quantidade = ifelse(str_detect(Produto,
                                        "[0-9]+(?=(?i)(kg|g|l|ml| un))"),
                             str_extract(Produto,
                                         "[0-9]+(?=(?i)(kg|g|l|ml| un))") %>%
                               str_squish() %>%
                               as.numeric() %>%
                               "*"(as.numeric(Quantidade)),
                             Quantidade),
         Medida = ifelse(str_detect(Produto,
                                    "[0-9]+(?=(?i)(kg|g|l|ml| un))"),
                         str_extract(Produto,
                                     "(?<=[0-9])(?i)(kg|g|l|ml| un)") %>%
                           str_squish() %>%
                           str_replace("UN", "UNIDADE") %>%
                           str_to_lower(),
                         Medida %>%
                           str_squish() %>%
                           str_replace("UN", "UNIDADE") %>%
                           str_to_lower()),
         Produto_n = Produto %>%
           str_to_lower(locale = "br") %>%
           str_squish() %>%
           str_remove_all("([0-9]+(?i)( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/))|(c/[0-9]+ un)|( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/)$|( b )"))

dic <- c("Feijão",
         "Massa",
         "Hamburguer de soja",
         "Milho e ervilha",
         "Óleo de soja",
         "Ovo",
         "Maionese",
         "Tapioca",
         "Leite condensado",
         "Sabonete",
         "Esponja",
         "Lava louça",
         "Água sanitária") %>%
  rm_accent() %>%
  str_to_lower(locale = "br")


tt <- refinr::key_collision_merge(shops$Produto, dict = dic)

unit <- c("kg", "g", "unidade", "l", "ml")
