#----------------------------------------------#
# Importing globalVariables from utils package #
#----------------------------------------------#
#' @noRd
#' @title Global vars
#' @importFrom utils globalVariables
#---------------------------------------------#
# Setting global variables of other functions #
#---------------------------------------------#
globalVariables(c(".",
                  "global",
                  "global_partials",
                  "credentials",
                  "value",
                  "Medida",
                  "Produto",
                  "Quantidade",
                  "X1",
                  "X2",
                  "X6",
                  "credentials"))

#' Globals partial
#'
#' @title Globals partials
#' @noRd
global_partials <- quote({shopper::global()})

#' @title Global
#'
#' @noRd
#' @importFrom scrypt hashPassword
global <- function(){

  credentials <<- data.frame(
    user = c("teste", "teste2"), # mandatory
    password = c(hashPassword("teste123"), hashPassword("teste321")), # mandatory
    is_hashed_password = TRUE,
    start = c(NA, NA), # optinal (all others)
    expire = c(NA, NA),
    admin = c(FALSE, TRUE),
    comment = "Simple applications.",
    stringsAsFactors = FALSE
  )
}
