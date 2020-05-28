#' @title plot_guzergah Function
#'
#' @description You can see the bus line route that you want in a map. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param linecode This is mandatory. You can query bus line with bus line code.
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
#' @importFrom leaflet leaflet
#' @importFrom leaflet addTiles
#' @importFrom leaflet addMarkers
#' @importFrom htmltools HTML
#' @examples  plot_guzergah(linecode="145T")
#'
#' @export

plot_guzergah <- function(linecode) {

  headerFields =
    c(Accept = "text/xml",
      Accept = "multipart/*",
      'Content-Type' = "text/xml; charset=utf-8",
      SOAPAction = "http://tempuri.org/DurakDetay_GYY")

  body = paste0(' <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <DurakDetay_GYY xmlns="http://tempuri.org/">
            <hat_kodu>',linecode,'</hat_kodu>
        </DurakDetay_GYY>
    </Body>
</Envelope> ')


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
  yonler$XKOORDINATI <- str_replace_all(yonler$XKOORDINATI,",",".")
  yonler$YKOORDINATI <- str_replace_all(yonler$YKOORDINATI,",",".")
  yonler <- as.data.frame(yonler)

  labs <- lapply(seq(nrow(yonler)), function(i) {
    paste0( '<p>', "Hat Kodu: ",yonler[i, "HATKODU"], '<p></p>',
            '<p>', "Durak Adı: ",yonler[i, "DURAKADI"],'<p></p>',
            '<p>',"Durak Tipi: ",yonler[i, "DURAKTIPI"],'</p><p>',
            "Durak İlçe: ",yonler[i, "ILCEADI"], '</p>' )
  })


  leaflet(data = yonler) %>% addTiles() %>%
    addMarkers(~as.numeric(XKOORDINATI), ~as.numeric(YKOORDINATI), popup = ~lapply(labs, htmltools::HTML), label = lapply(labs, htmltools::HTML))


}

