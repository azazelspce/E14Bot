file_methods = list()

file_methods$GetPath = NotImplemented
file_methods$GetID   = NotImplemented
file_methods$GetBody = NotImplemented
file_methods$Get     = NotImplemented

file_methods$CreateBaseURL = function( build_path_ = FALSE )
{
  create_url = paste( Sys.getenv( "DATABASE_PATH" ), GetPath(), sep = "/" )
  create_url = paste( create_url, GetID(), sep = "/" )

  if( build_path_ )
    if( !dir.exists( create_url ) )
    {
      dir.create( create_url, recursive = TRUE, showWarnings = FALSE )
      unlink( create_url, recursive = TRUE )
    }
  
  return( create_url )
}

file_methods$CreateURL = function( build_path_ = FALSE )
{
  create_url = CreateBaseURL( build_path_ )
    
  return( create_url )
}

file_methods$CreateDocument = function()
{
  time_stamp = as.character( as.numeric( as.POSIXct( Sys.time() ) ) )
  create_url = CreateURL( TRUE )
  body_      = GetBody()
  body_      = jsonlite::toJSON( body_, auto_unbox = TRUE )

  writeLines( body_, create_url )

  print( paste0( "Documment ", create_url, " created" ) )

  response = create_url
  
  return( response )
}

file_methods$Exists = function()
{
  full_name = CreateURL( FALSE )
  result = file.exists( full_name )

  return( result )
}

file_methods$Upload = function()
{
  body_ = GetBody()
  
  response = UpdateDocument( GetID(), GetPath(), body_ )

  return( response )
}

file_methods$Delete = function()
{
  create_url = paste( Sys.getenv( "DATABASE_PATH" ), GetPath(), GetID(), sep = "/" )

  response = 0

  return( response )
}

file_methods$UpdateDocument = function( document_id, url_string, body_ )
{
  url_     = Sys.getenv( "DATABASE_PATH" )
  url_     = paste( url_, url_string, document_id, sep = "/" )
  
  return( response )
}

class_   = "FileObject"
super_   = "TraceableObject"
methods_ = file_methods

FileObject = CreateTraceableClass( class_, super_, methods_ )
