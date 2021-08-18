locale_methods = list()
locale_fields  = list()

locale_fields$default_language = "character"
locale_fields$language_list    = "character"
locale_fields$languages_data   = "list"

locale_methods$SetDefaultLanguage = function( language )
{
  if( length( language_list ) == 0 )
  {
    stop( "There are no languages yet" )
  }
  
  default_language <<- language
  
  return( default_language )
}

locale_methods$AddLanguage = function( language, resource_path )
{
  language_list <<- c( language_list, language )
  languages_data[[language]] <<- read.locale( resource_path )

  return( default_language )
}

locale_methods$read.locale = function( file_name )
{
  col_classes = c( "character", "character" )
  result = read.csv( file_name, colClasses = col_classes, allowEscapes = T )
  return( result )
}

locale_methods$GetText = function( message_id, language )
{
  if( !( language %in% language_list ) )
  {
    language = language_list[1]
  }
  
  result = languages_data[[language]]
  index  = which( result$message_id == message_id )
  result = result$message_string
  result = result[index]
  
  if( length( index ) == 0 )
  {
    result = "Unknown text"
  }
  
  return( result )
}

locale_methods$initialize = function( ... )
{
  language_list <<- character()
  
  callSuper( ... )
}

class_   = "LocaleManager"
super_   = "TraceableObject"
methods_ = locale_methods
fields_  = locale_fields

LocaleManager = CreateTraceableClass( class_, super_, methods_, fields_ )
