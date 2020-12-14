#' @title Get link of QR Code on SEFAZ-RS receipt
#'
#' @usage get_qrcode_text(image)
#'
#' @param image A image file of QR Code in SEFAZ-RS receipt.
#'
#' @description Get text from QR Code on SEFAZ-RS receipt.
#'
#' @aliases qrcode
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
