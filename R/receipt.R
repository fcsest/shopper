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
#' @importFrom stringr str_replace str_detect str_extract str_squish str_to_lower str_remove_all str_remove
#' @importFrom abjutils rm_accent
#' @importFrom httr GET content
#' @importFrom xml2 read_html xml_find_all
#' @importFrom dplyr filter select mutate rename_with
get_sefaz_rs_rdata <- function(url){

  url %>%
    str_replace("NFCE/NFCE-COM.aspx", "ASP/AAE_ROOT/NFE/SAT-WEB-NFE-NFC_QRCODE_1.asp") %>%
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
    rename_with(~c("C\u00f3digo",
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
                                 str_replace(",", ".") %>%
                                 as.numeric() %>%
                                 "*"(as.numeric(str_replace(Quantidade,
                                                            ",",
                                                            "."))),
                               Quantidade %>%
                                 str_replace(",",
                                             ".") %>%
                                 as.numeric()),
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
           Produto_simplificado = Produto %>%
             str_to_lower(locale = "br") %>%
             str_squish() %>%
             str_remove_all("([0-9]+(?i)( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/))|(c/[0-9]+ un)|( kg| g| l| ml| un| c/|kg|g|l|ml|un|c/)$|( b )"))
}


#' Parse an html table into a data frame
#'
#' @param x A node, node set or document.
#' @param header Use first row as header? If NA, will use first row if it consists of th tags.
#' @param trim Remove leading and trailing whitespace within each cell?
#' @param fill If TRUE, automatically fill rows with fewer than the maximum number of columns with NAs.
#' @param dec The character used as decimal mark.
#'
#' @export
xml_table <- function(x, header = NA, trim = TRUE, fill = FALSE, dec = ".") {
  if ("xml_nodeset" %in% class(x)) {
    return(lapply(x, xml_table, header = header, trim = trim, fill = fill, dec = dec))
  }

  stopifnot(xml2::xml_name(x) == "table")
  rows <- xml2::xml_find_all(x, ".//tr")
  n <- length(rows)
  cells <- lapply(rows, xml2::xml_find_all, xpath = ".//td|.//th")
  ncols <- lapply(cells, xml2::xml_attr, "colspan", default = "1")
  ncols <- lapply(ncols, as.integer)
  nrows <- lapply(cells, xml2::xml_attr, "rowspan", default = "1")
  nrows <- lapply(nrows, as.integer)
  p <- unique(vapply(ncols, sum, integer(1)))
  maxp <- max(p)
  if (length(p) > 1 & maxp * n != sum(unlist(nrows)) & maxp * n != sum(unlist(ncols))) {
    if (!fill) {
      stop("Table has inconsistent number of columns. ", "Do you want fill = TRUE?", call. = FALSE)
    }
  }
  values <- lapply(cells, xml2::xml_text, trim = trim)
  out <- matrix(NA_character_, nrow = n, ncol = maxp)
  for (i in seq_len(n)) {
    row <- values[[i]]
    ncol <- ncols[[i]]
    col <- 1
    for (j in seq_len(length(ncol))) {
      out[i, col:(col + ncol[j] - 1)] <- row[[j]]
      col <- col + ncol[j]
    }
  }
  for (i in seq_len(maxp)) {
    for (j in seq_len(n)) {
      rowspan <- nrows[[j]][i]
      colspan <- ncols[[j]][i]
      if (!is.na(rowspan) & (rowspan > 1)) {
        if (!is.na(colspan) & (colspan > 1)) {
          nrows[[j]] <- c(
            utils::head(nrows[[j]], i),
            rep(rowspan, colspan - 1),
            utils::tail(nrows[[j]], length(rowspan) - (i + 1))
          )
          rowspan <- nrows[[j]][i]
        }
        for (k in seq_len(rowspan - 1)) {
          l <- utils::head(out[j + k, ], i - 1)
          r <- utils::tail(out[j + k, ], maxp - i + 1)
          out[j + k, ] <- utils::head(c(l, out[j, i], r), maxp)
        }
      }
    }
  }
  if (is.na(header)) {
    header <- all(xml2::xml_name(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, , drop = FALSE]
    out <- out[-1, , drop = FALSE]
  } else {
    col_names <- paste0("X", seq_len(ncol(out)))
  }
  df <- lapply(seq_len(maxp), function(i) {
    utils::type.convert(out[, i], as.is = TRUE, dec = dec)
  })
  names(df) <- col_names
  class(df) <- "data.frame"
  attr(df, "row.names") <- .set_row_names(length(df[[1]]))
  if (length(unique(col_names)) < length(col_names)) {
    warning("At least two columns have the same name")
  }
  df
}
