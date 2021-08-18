#!/usr/bin/env Rscript
library( httr )

source( "src/Logger.R"                  )
source( "src/Utils.R"                   )
source( "src/Classes/BaseObject.R"      )
source( "src/Classes/TraceableObject.R" )
source( "src/Classes/Auth.R"            )
source( "src/Classes/LocaleManager.R"   )
source( "src/Constants.R"               )
source( "src/Classes/FirebaseObject.R"  )
source( "src/Classes/User.R"            )
source( "src/Classes/UserActions.R"     )
source( "src/Classes/FormE14.R"         )

e14_2018_url = "https://elecciones1.registraduria.gov.co/e14_pre1_2018/e14"
carpeta_pdf  = "~/Documents/Repos/E14/PDF/"

authenticator = Authenticator$new( credentials_dev )

authenticator$UpdateAccessTokens()

ValidarDigitos0 = function( x )
{
  if( nchar( x ) == 1 ) return( paste0( "0", x ) )
  return( x )
}

ValidarDigitos1 = function( x )
{
  if( nchar( x ) == 1 ) return( paste0( "00", x ) )
  if( nchar( x ) == 2 ) return( paste0( "0" , x ) )
  return( x )
}

GetDepartamentos = function()
{
  body_ = list()
  
  body_$accion      = "cargar_departamentos_barra"
  body_$corp_activo = "presidente"
  body_$dep_activo  = "0"
  body_$token	      = "vacío"
  
  respuesta = POST( url = e14_2018_url, body = body_ )
  
  texto_raw = content( respuesta, type = "text", encoding = "UTF-8" )
  texto_raw = strsplit( x = texto_raw, split = "\n" )[[1]]
  texto_raw = gsub( ".*seleccionar_dep..", "", texto_raw, fixed = F )
  texto_raw = gsub( "\\'\\).*"           , "", texto_raw, fixed = F )
  
  lista_departamento = unique( texto_raw )
  lista_departamento = sapply( lista_departamento, ValidarDigitos0, USE.NAMES = F )
  
  return( lista_departamento )
}

departamentos_num = list()

departamentos_num["01"] = "Antioquia"
departamentos_num["03"] = "Atlántico"
departamentos_num["05"] = "Bolívar"
departamentos_num["07"] = "Boyacá"
departamentos_num["09"] = "Caldas"
departamentos_num["11"] = "Cauca"
departamentos_num["12"] = "Cesar"
departamentos_num["13"] = "Córdoba"
departamentos_num["15"] = "Cundinamarca"
departamentos_num["16"] = "Bogotá D.C "
departamentos_num["17"] = "Chocó"
departamentos_num["19"] = "Huila"
departamentos_num["21"] = "Magdalena"
departamentos_num["23"] = "Nariño"
departamentos_num["24"] = "Risaralda"
departamentos_num["25"] = "Norte de Santander"
departamentos_num["26"] = "Quindío"
departamentos_num["27"] = "Santander"
departamentos_num["28"] = "Sucre"
departamentos_num["29"] = "Tolima"
departamentos_num["31"] = "Valle del Cauca"
departamentos_num["40"] = "Arauca"
departamentos_num["44"] = "Caquetá"
departamentos_num["46"] = "Casanare"
departamentos_num["48"] = "La Guajira"
departamentos_num["50"] = "Guainía"
departamentos_num["52"] = "Meta"
departamentos_num["54"] = "Guaviare"
departamentos_num["56"] = "San Andrés y Providencia"
departamentos_num["60"] = "Amazonas"
departamentos_num["64"] = "Putumayo"
departamentos_num["68"] = "Vaupés"
departamentos_num["72"] = "Vichada"
departamentos_num["88"] = "Consulados"

municipios_num    = list()
zonas_num         = list()
puestos_num       = list()
mesas_num         = list()

GetMunicipios = function( departamento_ )
{
  body_ = list()
  
  body_$accion      = "cambiar_departamento"
  body_$dep_activo  = departamento_
  body_$corp_activo = "presidente"
  body_$token	      = "vacío"
  
  nombre_departamento = departamentos_num[[departamento_]]
  
  municipios_num[[nombre_departamento]] <<- list()
  zonas_num[[nombre_departamento]]      <<- list()
  
  respuesta = POST( url = e14_2018_url, body = body_ )
  texto_raw = content( respuesta, type = "text", encoding = "UTF-8" )
  texto_raw = strsplit( x = texto_raw, split = "</option><option " )[[1]]
  nombres   = gsub( ".*- ", "", texto_raw )
  nombres   = gsub( "<.*" , "", nombres   )
  texto_raw = gsub( "<option value=\"", "", texto_raw )
  texto_raw = gsub( "value=\""        , "", texto_raw )
  texto_raw = gsub( "\".*"            , "", texto_raw )
  texto_raw = gsub( "﻿"               , "", texto_raw )
  
  lista_municipios = unique( texto_raw )
  lista_municipios = sapply( lista_municipios, ValidarDigitos1, USE.NAMES = F )
  
  for( indice in 1:length( lista_municipios ) )
  {
    municipios_num[[nombre_departamento]][[lista_municipios[indice]]] <<- nombres[indice]
  }
  
  return( lista_municipios )
}

GetZonas = function( departamento_, municipio_ )
{
  body_ = list()
  
  body_$accion      = "cambiar_municipio"
  body_$dep_activo  = departamento_
  body_$mun_activo  = municipio_
  body_$corp_activo = "presidente"
  body_$token       = "vacío"
  
  nombre_departamento = departamentos_num[[departamento_]]
  nombre_municipio    = municipios_num[[nombre_departamento]][[municipio_]]

  zonas_num[[nombre_departamento]][[nombre_municipio]] <<- list()
  
  respuesta = POST( url = e14_2018_url, body = body_ )
  texto_raw = content( respuesta, type = "text", encoding = "UTF-8" )
  texto_raw = strsplit( x = texto_raw, split = "</option><option " )[[1]]
  invalido  = grepl( "-1", texto_raw )
  texto_raw = texto_raw[-invalido]
  nombres   = gsub( "</option>", "", texto_raw )
  nombres   = gsub( ".*>"      , "", nombres )
  texto_raw = gsub( "<option value=\"", "" , texto_raw )
  texto_raw = gsub( "value=\""        , "" , texto_raw )
  texto_raw = gsub( "\".*"            , "" , texto_raw )
  texto_raw = gsub( "﻿"               , "" , texto_raw )
  
  lista_zonas = unique( texto_raw )
  lista_zonas = sapply( lista_zonas, ValidarDigitos0, USE.NAMES = F )
  
  for( indice in 1:length( lista_zonas ) )
  {
    zonas_num[[nombre_departamento]][[nombre_municipio]][[lista_zonas[indice]]] <<- nombres[indice]
  }
  
  return( lista_zonas )
}

GetPuestos = function( departamento_, municipio_, zona_ )
{
  body_ = list()
  
  body_$accion      = "cambiar_zona"
  body_$dep_activo  = departamento_
  body_$mun_activo  = municipio_
  body_$zona_activo = zona_
  body_$corp_activo = "presidente"
  body_$token       = "vacío"
  
  nombre_departamento = departamentos_num[[departamento_]]
  nombre_municipio    = municipios_num[[nombre_departamento]][[municipio_]]
  nombre_zona         = zonas_num[[nombre_departamento]][[nombre_municipio]][[zona_]]
  
  puestos_num[[nombre_departamento]][[nombre_municipio]][[nombre_zona]] <<- list()
  
  respuesta = POST( url = e14_2018_url, body = body_ )
  texto_raw = content( respuesta, type = "text", encoding = "UTF-8" )
  texto_raw = strsplit( x = texto_raw, split = "</option><option " )[[1]]
  nombres   = gsub( ".*- "     , "", texto_raw )
  nombres   = gsub( "</option>", "", nombres   )
  texto_raw = gsub( "<option value =\"", "" , texto_raw )
  texto_raw = gsub( "value =\""       , "" , texto_raw )
  texto_raw = gsub( "\".*"            , "" , texto_raw )
  texto_raw = gsub( "﻿"               , "" , texto_raw )
  
  lista_puestos = unique( texto_raw )
  lista_puestos = sapply( lista_puestos, ValidarDigitos0, USE.NAMES = F )
  
  for( indice in 1:length( lista_puestos ) )
  {
    puestos_num[[nombre_departamento]][[nombre_municipio]][[nombre_zona]][[lista_puestos[indice]]] <<- nombres[indice]
  }
  
  return( lista_puestos )
}

global_counter <<- 0

GetMesas = function( departamento_, municipio_, zona_, puesto_ )
{
  body_ = list()
  body_$accion      = "cargar_mesas"
  body_$dep_activo  = departamento_
  body_$mun_activo  = municipio_
  body_$zona_activo	= zona_
  body_$pues_activo	= puesto_
  body_$corp_activo	= "presidente"
  body_$token	      = "vacío"
  
  nombre_departamento = departamentos_num[[departamento_]]
  nombre_municipio    = municipios_num[[nombre_departamento]][[municipio_]]
  nombre_zona         = zonas_num[[nombre_departamento]][[nombre_municipio]][[zona_]]
  nombre_puesto       = puestos_num[[nombre_departamento]][[nombre_municipio]][[nombre_zona]][[puesto_]]
  
  mesas_num[[nombre_departamento]][[nombre_municipio]][[nombre_zona]][[nombre_puesto]] = list()
  
  respuesta     = POST( url = e14_2018_url, body = body_ )
  texto_raw     = content( respuesta, type = "text", encoding = "UTF-8" )
  texto_raw     = strsplit( texto_raw, split = "\n" )[[1]]
  indice_valido = grepl( pattern = ".*pdf.*", x = texto_raw )
  texto_raw     = texto_raw[indice_valido]
  nombres       = gsub( pattern = ".*pdf" , replacement = ""    , x = texto_raw )
  nombres       = gsub( pattern = "</.*"  , replacement = ""    , x = nombres   )
  nombres       = gsub( pattern = ".*>"   , replacement = ""    , x = nombres   )
  texto_raw     = gsub( pattern = "pdf.*" , replacement = "pdf" , x = texto_raw )
  texto_raw     = gsub( pattern = ".*http", replacement = "http", x = texto_raw )
  
  if( sum( indice_valido ) == 0 )
  {
    return( list() )
  }
  
  lista_mesas = unique( texto_raw )
  
  for( indice in 1:length( lista_mesas ) )
  {
    nombre_archivo = lista_mesas[indice]
    nombre_archivo = unlist( strsplit( nombre_archivo, "/" ) )
    indice_valido  = grepl( "pdf", nombre_archivo )
    nombre_archivo = nombre_archivo[indice_valido]
    mesas_num[[nombre_departamento]][[nombre_municipio]][[nombre_zona]][[nombre_puesto]][[nombres[indice]]] <<- nombre_archivo
    
    temporal_e14 = FormE14$new( nombre_archivo )

    temporal_e14$departamento = nombre_departamento
    temporal_e14$municipio    = nombre_municipio
    temporal_e14$zona         = nombre_zona
    temporal_e14$puesto       = nombre_puesto
    temporal_e14$mesa         = nombres[indice]
    
    temporal_e14$CreateDocument()
    
    global_counter <<- global_counter + 1
  }
  
  return( lista_mesas )
}

lista_departamentos = GetDepartamentos()

lista_pdf = vector()

global_counter <<- 0

departamento_inicio = 4
municipio_inicio    = 1
zona_inicio         = 1
puesto_inicio       = 1

authenticator = Authenticator$new( credentials_dev )
authenticator$UpdateAccessTokens()

for( departamento in lista_departamentos[departamento_inicio:length( lista_departamentos )] )
{
  lista_municipios = GetMunicipios( departamento )
  
  for( municipio in lista_municipios[municipio_inicio:length( lista_municipios )] )
  {
    lista_zonas = GetZonas( departamento, municipio )

    for( zona in lista_zonas[zona_inicio:length( lista_zonas )] )
    {
      lista_puestos = GetPuestos( departamento, municipio, zona )
      
      for( puesto in lista_puestos[puesto_inicio:length( lista_puestos )] )
      {
        formato = "Departamento: %d, Municipio: %d, Zona: %d, Puesto: %d"
        departamento_index = which( lista_departamentos == departamento )
        municipio_index    = which( lista_municipios == municipio )
        zona_index         = which( lista_zonas == zona )
        puesto_index       = which( lista_puestos == puesto )

        mensaje = sprintf( formato, departamento_index, municipio_index, zona_index, puesto_index )
        print( mensaje )
        
        if( global_counter > 10000 )
        {
          stop( c( mensaje ) )
        }
        
        lista_mesas = GetMesas( departamento, municipio, zona, puesto )
        lista_pdf   = c( lista_pdf, lista_mesas )
      }
    }
  }
  break
}

formato = "Global counter: %d\nDepartamento: %s\nMunicipio: %s\nZona: %s\nPuesto: %s\n"

indice_departamento = which( departamento == lista_departamentos )
indice_municipio    = which( municipio    == lista_municipios    )
indice_zona         = which( zona         == lista_zonas         )
indice_puesto       = which( puesto       == lista_puestos       )

str_1 = paste0( indice_departamento, "/", length( lista_departamentos ) )
str_2 = paste0( indice_municipio   , "/", length( lista_municipios    ) )
str_3 = paste0( indice_zona        , "/", length( lista_zonas         ) )
str_4 = paste0( indice_puesto      , "/", length( lista_puestos       ) )

mensaje = sprintf( formato, global_counter, str_1, str_2, str_3, str_4 )

cat( mensaje )

lista_pdf = unique( lista_pdf )
