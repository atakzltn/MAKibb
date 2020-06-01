#' @title asd Function
#'
#' @description You can reach instant bad road information. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#'
#' @return NULL
#' @importFrom jsonlite fromJSON
#'
#' @export
#'


asd <- function() {
 df<-fromJSON("https://api.ibb.gov.tr/ispark/Park")
 return(df)
}
