#' @title get_lokasyon Function
#'
#' @description You can reach location and speed (km/h) of any bus with/without number plate. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param numberplate This is not mandatory. You can query with only number plate.
#'
#' @return NULL
#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
#' @importFrom xml2 as_xml_document
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_text
#' @importFrom XML xmlParse
#' @importFrom jsonlite fromJSON
#' @importFrom XML xmlToDataFrame
#' @examples  get_lokasyon(numberplate="34 NL 7572")
#'
#' @export

get_lokasyon <- function(numberplate) {


  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/GetFiloAracKonum_json")

  body = ' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <GetFiloAracKonum_json xmlns="http://tempuri.org/"/>
    </Body>
</Envelope> '


  reader = basicTextGatherer()

  curlPerform(
    url = "https://api.ibb.gov.tr/iett/FiloDurum/SeferGerceklesme.asmx?wsdl",
    httpheader = headerFields,
    postfields = body,
    writefunction = reader$update
  )

  df <- reader$value()

  df <- xmlParse(df)
  df <- xmlToDataFrame(df)
  df <- as.character(df$GetFiloAracKonum_jsonResponse)


  df <- fromJSON(df,flatten=T)

  ifelse(missing(numberplate),return(df),return(filter(df,df$Plaka  %in%  numberplate)))


}
get_lokasyon()
