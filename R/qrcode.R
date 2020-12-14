#' @title Get receipt data from link of SEFAZ-RS
#'
#' @usage get_sefaz_rs_rdata(url)
#'
#' @param url A receipt url of https://www.sefaz.rs.gov.br/
#'
#' @description Get data from receipt in https://www.sefaz.rs.gov.br/
#'
#' @aliases receipt
#'
#' @export
#' @importFrom magick image_read
#' @importFrom quadrangle qr_scan
#' @importFrom purrr pluck
#' @importFrom dplyr pull
get_qrcode_text <- function(image){

  image_read(image) %>%
    qr_scan(flop = F, no_js = F, plot = T) %>%
    pluck("values") %>%
    pull(value)
}
