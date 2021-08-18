user_fields                 = list()
user_fields$first_name      = "character"
user_fields$username        = "character"
user_fields$telegram_id     = "character"
user_fields$current_form    = "numeric"
user_fields$current_message = "character"
user_fields$count           = "numeric"

user_methods = list()

user_methods$GetPath = function()
{
  return( "documents/User" )
}

user_methods$GetBody = function()
{
  body_ = list()
  
  body_$first_name      = first_name
  body_$username        = username
  body_$telegram_id     = telegram_id
  body_$current_form    = current_form
  body_$current_message = current_message
  body_$count           = count

  return( body_ )
}

user_methods$Get = function()
{
  if( Exists() )
  {
    result = jsonlite::fromJSON( readLines( CreateURL( FALSE ) ) )

    first_name      <<- result$first_name
    username        <<- result$username
    telegram_id     <<- result$telegram_id
    current_form    <<- result$current_form
    current_message <<- result$current_message
    count           <<- result$count

    return( "User loaded" )
  }

  return( "User not found" )
}

user_methods$GetID = function()
{
  return( telegram_id )
}

user_methods$initialize = function( telegram_id_, first_name_, username_, ... )
{
  print( telegram_id_ )

  first_name      <<- first_name_
  username        <<- username_
  telegram_id     <<- telegram_id_
  current_form    <<- -1
  current_message <<- ""
  count           <<- 0

  callSuper( ... )
}

class_   = "User"
super_   = "FileObject"
methods_ = user_methods
fields_  = user_fields

User = CreateTraceableClass( class_, super_, methods_, fields_ )
