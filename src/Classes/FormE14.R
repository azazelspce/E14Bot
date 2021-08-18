form_e14_fields              = list()
form_e14_fields$id           = "character"
form_e14_fields$file_name    = "character"
form_e14_fields$count_id     = "list"
form_e14_fields$departamento = "character"
form_e14_fields$municipio    = "character"
form_e14_fields$zona         = "character"
form_e14_fields$mesa         = "character"
form_e14_fields$puesto       = "character"

form_e14_methods = list()

form_e14_methods$GetPath = function()
{
  return( "documents/FormE14" )
}

form_e14_methods$GetBody = function()
{
  body_        = list()
  body_$fields = list()
  
  body_$fields$id           = list( "stringValue" = id           )
  body_$fields$file_name    = list( "stringValue" = file_name    )
  body_$fields$count_id     = list( "arrayValue"  = count_id     )
  body_$fields$departamento = list( "stringValue" = departamento )
  body_$fields$municipio    = list( "stringValue" = municipio    )
  body_$fields$zona         = list( "stringValue" = zona         )
  body_$fields$mesa         = list( "stringValue" = mesa         )
  body_$fields$puesto       = list( "stringValue" = puesto       )
  
  return( body_ )
}

form_e14_methods$Get = function()
{
  response = QueryGetAll()

  if( is.null( response ) || !is.null( response$error ) )
  {
    return( FALSE )
  }
  
  file_name    <<- response$fields$file_name$stringValue
  count_id     <<- response$fields$count_id$arrayValue
  departamento <<- response$fields$departamento$stringValue
  municipio    <<- response$fields$municipio$stringValue
  zona         <<- response$fields$zona$stringValue
  mesa         <<- response$fields$mesa$stringValue
  puesto       <<- response$fields$puesto$stringValue
  
  return( response )
}

form_e14_methods$GetID = function()
{
  return( id )
}

form_e14_methods$initialize = function( form_id, ... )
{
  id           <<- form_id
  file_name    <<- form_id
  count_id     <<- list( "values" = list() )
  departamento <<- ""
  municipio    <<- ""
  zona         <<- ""
  mesa         <<- ""
  puesto       <<- ""

  callSuper( ... )
}

class_   = "Exam"
super_   = "FirebaseObject"
methods_ = form_e14_methods
fields_   = form_e14_fields

FormE14 = CreateTraceableClass( class_, super_, methods_, fields_ )
