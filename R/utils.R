#' URL ERDDAP Bio-Oracle website
#'
#' @details
#'
#' Reads Bio-Oracle ERDDAP url from options: ERDDAP.BIO-ORACLE.URL
#' Use for debugging
#'
#' @noRd
erddap.bio_oracle.org <- function(){
  getOption("ERDDAP.BIO-ORACLE.URL", "http://erddap.bio-oracle.org/erddap/")
}


