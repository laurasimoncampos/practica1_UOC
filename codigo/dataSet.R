


install.packages('rvest')
install.packages('stringr')
install.packages('tidyr')

library(rvest)
library(stringr)
library(tidyr)

direccionWeb = "https://www.paxinasgalegas.es"
enlaceLocalidad ="/empresas-santiago-de-compostela-79ay.html"

url = paste(direccionWeb,enlaceLocalidad,sep="")
url
webpage  <- read_html(url)
webpage

#url actividad
urlActividades <- webpage %>%
  html_nodes("#dvEpigrafes .columnaEpigrafes a") %>%
  html_attr("href")
urlActividades


#nombre de las actividades
nombreActividad <- webpage %>%
  html_nodes("#dvEpigrafes .columnaEpigrafes a") %>%
  html_attr("title")
nombreActividad




length(urlActividades)
totalEmpresas<-c("Nombre","Telefono","Dirección","Latitud","Longitud","Pagina Web","Correo Electronico","Descripcion","Actividad","Sub actividad")


#for (i in 1:3) {
  
  urlActividad = paste(direccionWeb,urlActividades[1],sep="")
  
  
  webpageActivity  <- read_html(urlActividad)

  
  #url de las subactividades
  urlSubActividades <- webpageActivity %>%
    html_nodes("#dvContDirectorio a") %>%
    html_attr("href")
  print(length(urlSubActividades))
  
  #nombre de las subactividades
  nombreSubActividad <- webpageActivity %>%
    html_nodes("#dvContDirectorio a") %>%
    html_text()
  
  
  for (j in 1:length(urlSubActividades)) {
    
    urlSubActividad = paste(direccionWeb,urlSubActividades[j],sep="")
    print(urlSubActividad)
    webpageSubActivity  <- read_html(urlSubActividad)
    
    #nombre
    nombre <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-name") 

    
    #telefono
    telefono <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-telf") 

    #correo
    correo <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-mail") 

    #paginaWeb
    paginaWeb <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-empuri") 

    #direccion
    direccion <- webpageSubActivity %>%
      html_nodes(".cabecera .wrapper .wrapper .calle") %>%
      html_text()
    
    print(direccion)
    
    #latitud
    latitud <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-lat")

    #longitud
    longitud <- webpageSubActivity %>%
      html_nodes(".original li") %>%
      html_attr("data-lng")

    #descripcion
    descripcion <- webpageSubActivity %>%
      html_nodes(" .cabecera .wrapper .contenido p") %>%
      html_text()

    print(nombreActividad[i])
    print(nombreSubActividad[j])
    
    empresa<- cbind(nombre, telefono, direccion, latitud, longitud, paginaWeb, correo, descripcion, nombreActividad[1], nombreSubActividad[j])

    totalEmpresas <- rbind(totalEmpresas , empresa)
    #CREAR CSV CON LOS DATOS
    write.table(totalEmpresas,file="dataset.csv", row.names=FALSE, col.names = FALSE, sep=",")


  }
  
  
#}









