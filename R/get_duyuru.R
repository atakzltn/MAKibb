#' @title get_duyuru Function
#'
#' @description You can reach daily announcements by type and bus line. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#'
#' @return NULL
#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
#' @importFrom xml2 as_xml_document
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_text
#' @importFrom XML xmlToDataFrame
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom stringr str_replace_all
#'
#' @export

get_duyuru <- function(){

  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/GetDuyurular_XML")

  body = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
  <Body>
  <GetDuyurular_json xmlns="http://tempuri.org/"/>
  </Body>
  </Envelope>'


  reader = basicTextGatherer()

  curlPerform(
    url = "https://api.ibb.gov.tr/iett/UlasimDinamikVeri/Duyurular.asmx?wsdl",
    httpheader = headerFields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()

  xml3 <- as_xml_document(xml)

  # get all the <record>s

  HAT <-xml_find_all(xml3, "//HAT")
  TIP <-xml_find_all(xml3, "//TIP")
  GUNCELLEME <-xml_find_all(xml3, "//GUNCELLEME_SAATI")
  MESAJ <-xml_find_all(xml3, "//MESAJ")

  tip <- trimws(xml_text(TIP))
  hat <- trimws(xml_text(HAT))
  guncelleme <- trimws(xml_text(GUNCELLEME))
  mesaj <- trimws(xml_text(MESAJ))

  tip2 <- as.data.frame(tip)
  hat2 <- as.data.frame(hat)
  guncelleme2 <- as.data.frame(guncelleme)
  mesaj2 <- as.data.frame(mesaj)

  mesaj_yayini <- data.frame(tip2,hat2,guncelleme2,mesaj2)


  mesaj_yayini$guncelleme <- str_replace_all(mesaj_yayini$guncelleme, "Kayıt Saati: ", "")
  mesaj_yayini$guncelleme<-as.character(strptime(mesaj_yayini$guncelleme, "%H:%M"),format="%H:%M")

  mesaj_yayini<-arrange(mesaj_yayini,desc(mesaj_yayini$guncelleme))

  colnames(mesaj_yayini)<-c("Tip","Hat","Güncelleme","Mesaj")

  return(mesaj_yayini)

}

