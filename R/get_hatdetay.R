#' @title get_hatdetay Function
#'
#' @description You can reach all the route and bus stop information instantly with this function. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
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
#' @examples  get_hatdetay(linecode="145T")
#'
#' @export

get_hatdetay <- function(linecode) {

  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/HatServisi_GYY")

  ifelse(missing(linecode),
         (body = ' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <HatServisi_GYY xmlns="http://tempuri.org/">
            <hat_kodu></hat_kodu>
        </HatServisi_GYY>
    </Body>
</Envelope> '),
         (body = paste0(' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <HatServisi_GYY xmlns="http://tempuri.org/">
            <hat_kodu>',linecode,'</hat_kodu>
        </HatServisi_GYY>
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

  HAT_KODU <- xml_find_all(xml3, "//HAT_KODU")
  HAT_ADI <- xml_find_all(xml3, "//HAT_ADI")
  HAT_DURUMU <- xml_find_all(xml3, "//HAT_DURUMU")
  BOLGE <- xml_find_all(xml3, "//BOLGE")
  SEFER_SURESI <- xml_find_all(xml3, "//SEFER_SURESI")


  HATKODU <- trimws(xml_text(HAT_KODU))
  HATADI <- trimws(xml_text(HAT_ADI))
  HATDURUMU <- trimws(xml_text(HAT_DURUMU))
  BOLGE <- trimws(xml_text(BOLGE))
  SEFERSURESI <- trimws(xml_text(SEFER_SURESI))

  HATKODU <- as.data.frame(HATKODU)
  HATADI <- as.data.frame(HATADI)
  HATDURUMU <- as.data.frame(HATDURUMU)
  BOLGE <- as.data.frame(BOLGE)
  SEFERSURESI <- as.data.frame(SEFERSURESI)


  hatlistesi <- data.frame(HATKODU,HATADI,HATDURUMU,BOLGE,SEFERSURESI)
  return(hatlistesi)

}
