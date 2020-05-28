#' @title get_durakdetay Function
#'
#' @description You can reach line code, line name, line situation, area and journey time instantly with this function. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param linecode You can make a query with/without bus line code.
#'
#' @return NULL
#' @importFrom RCurl basicTextGatherer
#' @importFrom RCurl curlPerform
#' @importFrom xml2 as_xml_document
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_text
#' @examples  get_durakdetay(linecode="145T")
#'
#' @export

get_durakdetay <- function(linecode) {

  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/DurakDetay_GYY")

  ifelse(missing(linecode),
         (body = ' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <DurakDetay_GYY xmlns="http://tempuri.org/">
            <hat_kodu></hat_kodu>
        </DurakDetay_GYY>
    </Body>
</Envelope> '),
         (body = paste0(' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <DurakDetay_GYY xmlns="http://tempuri.org/">
            <hat_kodu>',linecode,'</hat_kodu>
        </DurakDetay_GYY>
    </Body>
</Envelope> ')))


  reader = basicTextGatherer()

  curlPerform(
    url = "https://api.ibb.gov.tr/iett/ibb/ibb.asmx?wsdl",
    httpheader = headerFields,
    postfields = body,
    writefunction = reader$update
  )

  xml <- reader$value()

  xml3 <- as_xml_document(xml)

  HATKODU <- xml_find_all(xml3, "//HATKODU")
  DURAKKODU <- xml_find_all(xml3, "//DURAKKODU")
  XKOORDINATI <- xml_find_all(xml3, "//XKOORDINATI")
  YKOORDINATI <- xml_find_all(xml3, "//YKOORDINATI")
  DURAKADI <- xml_find_all(xml3, "//DURAKADI")
  YON <- xml_find_all(xml3, "//YON")
  DURAKTIPI <- xml_find_all(xml3, "//DURAKTIPI")
  ILCEADI <- xml_find_all(xml3, "//ILCEADI")
  SIRANO <- xml_find_all(xml3, "//SIRANO")




  HATKODU <- trimws(xml_text(HATKODU))
  DURAKKODU <- trimws(xml_text(DURAKKODU))
  XKOORDINATI <- trimws(xml_text(XKOORDINATI))
  YKOORDINATI <- trimws(xml_text(YKOORDINATI))
  DURAKADI <- trimws(xml_text(DURAKADI))
  DURAKTIPI <- trimws(xml_text(DURAKTIPI))
  YON <- trimws(xml_text(YON))
  ILCEADI <- trimws(xml_text(ILCEADI))
  SIRANO <- trimws(xml_text(SIRANO))



  HATKODU <- as.data.frame(HATKODU)
  DURAKKODU <- as.data.frame(DURAKKODU)
  XKOORDINATI <- as.data.frame(XKOORDINATI)
  YKOORDINATI <- as.data.frame(YKOORDINATI)
  DURAKADI <- as.data.frame(DURAKADI)
  DURAKTIPI <- as.data.frame(DURAKTIPI)
  YON <- as.data.frame(YON)
  ILCEADI <- as.data.frame(ILCEADI)
  SIRANO <- as.data.frame(SIRANO)



  yonler <- data.frame(HATKODU,YON,SIRANO,DURAKKODU,XKOORDINATI,YKOORDINATI,DURAKADI,DURAKTIPI,ILCEADI)
  return(yonler)

}
