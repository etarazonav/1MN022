#==============================================================================#
## Laboratorio N°3: Web Scrapping con R                                       ##
#==============================================================================##
library(dplyr)

################################################################################
## Ejemplo 1: Obtener Datos de una API                                        ##
################################################################################
library(httr)
library(jsonlite)

# ------------------------------------------------------------------------------ 
## Enlace de la API con datos de todas las razas de los perros
url = "https://dogapi.dog/api/v2/breeds"

# Conectarse a la API
res <- GET(url)
res

# Obtener información de la API
datos <- fromJSON(content(res, "text"))

# Guardar los datos de las razas de perros como una tabla (dataframe)
dogs<- datos$data
head(dogs)

# Mostrar los datos de la primera raza de perros
dogs[1,]

# Mostrar las razas de perros con esperanza de vida mínima mayor a 13 años
dogs[dogs$attributes$life$min > 13,]$attributes$name

# ------------------------------------------------------------------------------ 
## Enlace de la API con datos de una raza de perro en particular
breed_id =  "68f47c5a-5115-47cd-9849-e45d3c378f12"
url2 = paste("https://dogapi.dog/api/v2/breeds/{",breed_id,"}",sep="")

# Conectarse a la API
res2 = GET(url2)
res2

# Obtener información de la API
datos2 <- fromJSON(content(res2, "text"))

# Guardar los datos de la raza de perro seleccionada
dog<- as.data.frame(datos2$data)
head(dog)
    
# Conectarse a una API con parámetros
#res3 = GET(url2,query = list(id = breed_id))
# ------------------------------------------------------------------------------
# Obtener el enlace de la siguiente página
next_url = datos$links$`next`
next_url

# Conectarse a la API
res_next = GET(next_url)
res_next

# Obtener los datos de la siguiente página
datos_next <- fromJSON(content(res_next, "text"))

# Guardar los datos de las razas de perros de la siguiente página
dogs_2<- datos_next$data
head(dogs_2)


################################################################################
## Ejemplo 2: Obtener Datos de una página HTML simple                         ##
################################################################################
library(rvest)

# Obtener la información del sitio web
url <- "web_simple.html"
contenido <- read_html(url,encoding =  "UTF-8")
contenido
class(contenido)

# Encontrar el primer tag <h1> en el archivo HTML e imprimir su texto
resultado1 <- contenido %>%
  html_element(css = "h1") %>%
  html_text()
resultado1

# Encontrar todos los tags <li> en el archivo HTML
resultado2 <- contenido %>%
  html_elements(css = "li") %>%
  html_text() 
resultado2

# Encontrar el primer tag <a> en el archivo HTML e imprimir el atributo href
resultado3 <- contenido %>%
  html_element(css = "a") %>%
  html_attr("href")
resultado3

# Encontrar el tag con id "fecha" en el archivo HTML
resultado4 <- contenido %>%
  html_elements(css ="#fecha") %>%
  html_text2() 
resultado4

# Encontrar el primer tag con clase "precipitaciones" en el archivo HTML
resultado5 <- contenido %>%
  html_element(css =".precipitaciones") %>%
  html_text2() 
resultado5

# Encontrar el tag <li> con clase "precipitaciones" en el archivo HTML
resultado6 <- contenido %>%
  html_elements(css = "li.precipitaciones") %>%
  html_text2() 
resultado6

################################################################################
## Ejemplo 3: Obtener una tabla de una página HTML en la web                  ##
################################################################################

link <- "https://en.wikipedia.org/wiki/List_of_Formula_One_drivers"
page <- read_html(link)


drivers_F1 <- page %>% 
  html_element("table.sortable") %>%
  html_table()

View(drivers_F1)

