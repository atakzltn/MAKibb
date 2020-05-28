#' @title get_bozukyol Function
#'
#' @description You can reach instant bad road information. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param busdoornumber This parameter is not mandatory. This information is the information that comes to the bus driver screens. For this reason, you can also query bad roads by the bus door number.
#'
#' @return NULL
#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
#' @importFrom xml2 as_xml_document
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_text
#' @importFrom dplyr filter
#' @examples  get_bozukyol(busdoornumber="B4042")
#'
#' @export



get_bozukyol <- function(busdoornumber) {

  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/GetBozukSatih_XML")

  body = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <GetBozukSatih_XML xmlns="http://tempuri.org/"/>
    </Body>
</Envelope>'


  reader = basicTextGatherer()

  curlPerform(
    url = "https://api.ibb.gov.tr/iett/FiloDurum/SeferGerceklesme.asmx?wsdl",
    httpheader = headerFields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()

  xml3 <- as_xml_document(xml)

  # get all the <record>s

  NBOYLAM <-xml_find_all(xml3, "//NBOYLAM")
  NENLEM <-xml_find_all(xml3, "//NENLEM")
  SKAPINUMARASI <-xml_find_all(xml3, "//SKAPINUMARASI")



  boylam <- trimws(xml_text(NBOYLAM))
  enlem <- trimws(xml_text(NENLEM))
  kapinumarasi <- trimws(xml_text(SKAPINUMARASI))

  boylam <- as.data.frame(boylam)
  enlem <- as.data.frame(enlem)
  kapinumarasi <- as.data.frame(kapinumarasi)



  bozuk_haritasi <- data.frame(boylam,enlem,kapinumarasi)

  bozuk_haritasi$boylam <- as.numeric(trimws(bozuk_haritasi$boylam))
  bozuk_haritasi$enlem <- as.numeric(trimws(bozuk_haritasi$enlem))


  bozuk_haritasi<-as.data.frame(bozuk_haritasi)
  ifelse(missing(busdoornumber),return(bozuk_haritasi),return(filter(bozuk_haritasi,bozuk_haritasi$kapinumarasi %in% busdoornumber)))


}
