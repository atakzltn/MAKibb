#' @title get_ispark Function
#'
#' @description You can reach location and speed (km/h) of any bus with/without number plate. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#'
#' @return NULL
#' @importFrom jsonlite fromJSON
#'
#' @export



get_ispark <- function() {

  df<-fromJSON("https://api.ibb.gov.tr/ispark/Park")

}
