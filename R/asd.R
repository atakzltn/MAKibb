#' @title asd Function
#'
#' @description You can reach instant bad road information. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param busdoornumber This parameter is not mandatory. This information is the information that comes to the bus driver screens. For this reason, you can also query bad roads by the bus door number.
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
