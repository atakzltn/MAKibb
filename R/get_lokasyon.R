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
#' @importFrom stringr str_replace_all
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

  df$Operator <- str_replace_all(df$Operator,"Ö","O")
  df$Operator <- str_replace_all(df$Operator,"Ü","U")
  df$Operator <- str_replace_all(df$Operator,"Ş","S")
  df$Operator <- str_replace_all(df$Operator,"İ","I")
  df$Operator <- str_replace_all(df$Operator,"Ü","U")
  df$Operator <- str_replace_all(df$Operator,"Ğ","G")
  df$Operator <- str_replace_all(df$Operator,"İ","I")
  df$Operator <- str_replace_all(df$Operator,"Ç","C")
  df$Operator <- str_replace_all(df$Operator,"ş","s")
  df$Operator <- str_replace_all(df$Operator,"ç","c")
  df$Operator <- str_replace_all(df$Operator,"ğ","g")
  df$Operator <- str_replace_all(df$Operator,"ı","i")
  df$Operator <- str_replace_all(df$Operator,"ü","u")
  df$Operator <- str_replace_all(df$Operator,"ö","o")

  df$Garaj <- str_replace_all(df$Garaj,"Ö","O")
  df$Garaj <- str_replace_all(df$Garaj,"Ü","U")
  df$Garaj <- str_replace_all(df$Garaj,"Ş","S")
  df$Garaj <- str_replace_all(df$Garaj,"İ","I")
  df$Garaj <- str_replace_all(df$Garaj,"Ü","U")
  df$Garaj <- str_replace_all(df$Garaj,"Ğ","G")
  df$Garaj <- str_replace_all(df$Garaj,"İ","I")
  df$Garaj <- str_replace_all(df$Garaj,"Ç","C")
  df$Garaj <- str_replace_all(df$Garaj,"ş","s")
  df$Garaj <- str_replace_all(df$Garaj,"ç","c")
  df$Garaj <- str_replace_all(df$Garaj,"ğ","g")
  df$Garaj <- str_replace_all(df$Garaj,"ı","i")
  df$Garaj <- str_replace_all(df$Garaj,"ü","u")
  df$Garaj <- str_replace_all(df$Garaj,"ö","o")

  df$KapiNo <- str_replace_all(df$KapiNo,"Ö","O")
  df$KapiNo <- str_replace_all(df$KapiNo,"Ü","U")
  df$KapiNo <- str_replace_all(df$KapiNo,"Ş","S")
  df$KapiNo <- str_replace_all(df$KapiNo,"İ","I")
  df$KapiNo <- str_replace_all(df$KapiNo,"Ü","U")
  df$KapiNo <- str_replace_all(df$KapiNo,"Ğ","G")
  df$KapiNo <- str_replace_all(df$KapiNo,"İ","I")
  df$KapiNo <- str_replace_all(df$KapiNo,"Ç","C")
  df$KapiNo <- str_replace_all(df$KapiNo,"ş","s")
  df$KapiNo <- str_replace_all(df$KapiNo,"ç","c")
  df$KapiNo <- str_replace_all(df$KapiNo,"ğ","g")
  df$KapiNo <- str_replace_all(df$KapiNo,"ı","i")
  df$KapiNo <- str_replace_all(df$KapiNo,"ü","u")
  df$KapiNo <- str_replace_all(df$KapiNo,"ö","o")

  df$Plaka <- str_replace_all(df$Plaka,"Ö","O")
  df$Plaka <- str_replace_all(df$Plaka,"Ü","U")
  df$Plaka <- str_replace_all(df$Plaka,"Ş","S")
  df$Plaka <- str_replace_all(df$Plaka,"İ","I")
  df$Plaka <- str_replace_all(df$Plaka,"Ü","U")
  df$Plaka <- str_replace_all(df$Plaka,"Ğ","G")
  df$Plaka <- str_replace_all(df$Plaka,"İ","I")
  df$Plaka <- str_replace_all(df$Plaka,"Ç","C")
  df$Plaka <- str_replace_all(df$Plaka,"ş","s")
  df$Plaka <- str_replace_all(df$Plaka,"ç","c")
  df$Plaka <- str_replace_all(df$Plaka,"ğ","g")
  df$Plaka <- str_replace_all(df$Plaka,"ı","i")
  df$Plaka <- str_replace_all(df$Plaka,"ü","u")
  df$Plaka <- str_replace_all(df$Plaka,"ö","o")

  ifelse(missing(numberplate),return(df),return(filter(df,df$Plaka  %in%  numberplate)))


}


