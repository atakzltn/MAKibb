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
  stringi::stri_escape_unicode(c("Ü","İ","Ö","Ç","Ğ","Ş","u","ı","ö","ç","ğ","ş","Â","-"))
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

  xml <- str_replace_all(xml,"Ö","O")
  xml <- str_replace_all(xml,"Ü","U")
  xml <- str_replace_all(xml,"Ş","S")
  xml <- str_replace_all(xml,"İ","I")
  xml <- str_replace_all(xml,"Ü","U")
  xml <- str_replace_all(xml,"Ğ","G")
  xml <- str_replace_all(xml,"İ","I")
  xml <- str_replace_all(xml,"Ç","C")
  xml <- str_replace_all(xml,"ş","s")
  xml <- str_replace_all(xml,"ç","c")
  xml <- str_replace_all(xml,"ğ","g")
  xml <- str_replace_all(xml,"ı","i")
  xml <- str_replace_all(xml,"ü","u")
  xml <- str_replace_all(xml,"ö","o")
  xml <- str_replace_all(xml,"Â","A")

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

  colnames(mesaj_yayini)<-c("Tip","Hat","Guncelleme","Mesaj")

  mesaj_yayini<-as.data.frame(mesaj_yayini)

  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ö","O")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ü","U")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ş","S")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"İ","I")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ü","U")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ğ","G")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"İ","I")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Ç","C")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ş","s")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ç","c")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ğ","g")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ı","i")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ü","u")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"ö","o")
  mesaj_yayini$Tip <- str_replace_all(mesaj_yayini$Tip,"Â","A")

  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ö","O")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ü","U")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ş","S")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"İ","I")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ü","U")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ğ","G")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"İ","I")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Ç","C")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ş","s")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ç","c")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ğ","g")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ı","i")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ü","u")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"ö","o")
  mesaj_yayini$Hat <- str_replace_all(mesaj_yayini$Hat,"Â","A")

  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ö","O")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ü","U")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ş","S")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"İ","I")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ü","U")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ğ","G")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"İ","I")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Ç","C")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ş","s")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ç","c")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ğ","g")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ı","i")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ü","u")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"ö","o")
  mesaj_yayini$Mesaj <- str_replace_all(mesaj_yayini$Mesaj,"Â","A")








  return(mesaj_yayini)

}

