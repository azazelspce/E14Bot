actions_fields              = list()
actions_fields$id           = "character"
actions_fields$board        = "character"
actions_fields$selected     = "character"
actions_fields$input        = "character"
actions_fields$message_id   = "character"
actions_fields$link_user_id = "character"

actions_methods = list()

actions_methods$GetPath = function()
{
  return( "documents/Actions" )
}

actions_methods$GetBody = function()
{
  body_        = list()
  body_$fields = list()
  
  body_$fields$id           = list( "stringValue" = id           )
  body_$fields$board        = list( "stringValue" = board        )
  body_$fields$selected     = list( "stringValue" = selected     )
  body_$fields$input        = list( "stringValue" = input        )
  body_$fields$message_id   = list( "stringValue" = message_id   )
  body_$fields$link_user_id = list( "stringValue" = link_user_id )

  return( body_ )
}

actions_methods$Get = function()
{
  response = QueryGetAll()

  if( is.null( response ) || !is.null( response$error ) )
  {
    return( FALSE )
  }

  id           <<- response$fields$id$stringValue
  board        <<- response$fields$board$stringValue
  selected     <<- response$fields$selected$stringValue
  input        <<- response$fields$input$stringValue
  message_id   <<- response$fields$message_id$stringValue
  link_user_id <<- response$fields$link_user_id$stringValue

  return( response )
}

actions_methods$GetID = function()
{
  return( id )
}

actions_methods$initialize = function( id_, ... )
{
  id           <<- id_
  board        <<- ""
  selected     <<- ""
  input        <<- ""
  message_id   <<- ""
  link_user_id <<- ""

  callSuper( ... )
}

class_   = "UserActions"
super_   = "FileObject"
methods_ = actions_methods
fields_  = actions_fields

UserActions = CreateTraceableClass( class_, super_, methods_, fields_ )
