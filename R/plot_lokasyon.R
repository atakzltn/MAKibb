#' @title plot_lokasyon Function
#'
#' @description You can see the bus location that you want in a map. See \url{https://data.ibb.gov.tr/organization/iett-genel-mudurlugu} for more information.
#' @export
#'
#' @param numberplate This is mandatory. You can query bus with bus' number plate.
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
#' @importFrom dplyr %>%
#' @name %>%
#' @rdname pipe
#' @examples  plot_lokasyon(numberplate="34 NL 7572")
#'
#' @export


plot_lokasyon <- function(numberplate) {

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


  if (missing(numberplate)) {
    df2 <- df
  } else {
    df2 <- filter(df,df$Plaka %in% numberplate)
  }

  labs <- lapply(seq(nrow(df2)), function(i) {
    paste0( '<p>', "Operatör: ",df2[i, "Operator"], '<p></p>',
            '<p>', "Garaj: ",df2[i, "Garaj"],'<p></p>',
            '<p>',"Kapı No: ",df2[i, "KapiNo"],'</p><p>',
            '<p>',"Güncellenme Saati: ",df2[i, "Saat"],'</p><p>',
            '<p>',"Plaka: ",df2[i, "Plaka"],'</p><p>',
            "Araç Hızı (km): ",df2[i, "Hiz"], '</p>' )
  })

  leaflet(data = df2) %>% addTiles() %>%
    addMarkers(~as.numeric(df2$Boylam), ~as.numeric(df2$Enlem) ,popup = ~lapply(labs, htmltools::HTML), label = lapply(labs, htmltools::HTML))


}
