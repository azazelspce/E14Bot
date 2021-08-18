GetCurrentTimeVector = function()
{
  result = as.character( date() )
  result = gsub( " +", " ", as.character( date() ) )
  result = strsplit( result, " " )
  result = unlist( result )[4]
  result = strsplit( result, ":" )
  result = unlist( result )
  result = as.numeric( result )
  
  return( result )
}

SplitName = function( name_string )
{
  split_name = strsplit( name_string, " " )
  split_name = unlist( split_name )[1]

  return( split_name )
}

GenerateUniqueID = function( size_str = 20 )
{
  unique_id = c( 0:9, letters, LETTERS )
  unique_id = sample( unique_id, size = size_str, replace = T )
  unique_id = paste( unique_id, collapse = "" )
  
  return( unique_id )
}

GetLanguage = function( update )
{
  language_list         = list()
  language_list[["en"]] = "English"
  language_list[["es"]] = "Español"
  
  language = update$message$from$language_code
  
  if( is.null( update$message ) )
  {
    language = update$callback_query$from$language_code
  }
  
  if( is.null( language ) )
  {
    language = "en"
  }
  
  language = language_list[[language]]
  
  if( is.null( language ) )
  {
    language = "English"
  }
  
  return( language )
}

GetChatID = function( update_ )
{
  chat_id = update_$message$chat_id
  
  if( is.null( update_$message ) )
  {
    chat_id = update_$callback_query$from$id
  }
  
  chat_id = as.character( chat_id )
  
  return( chat_id )
}

GetFirstName = function( update_ )
{
  first_name = update_$message$chat$first_name
  
  if( is.null( update_$message ) )
  {
    first_name = update_$callback_query$from$first_name
  }
  
  first_name = as.character( first_name )
  
  return( first_name )
}

GetUsername = function( update_ )
{
  username = update_$message$chat$username
  
  if( is.null( update_$message ) )
  {
    username = update_$callback_query$from$username
  }
  
  username = as.character( username )
  
  return( username )
}

AddCommandHandler = function( name_, handler_ )
{
  handler_ = AddLog( handler_, paste( name_, "CommandHandler", sep = "" ) )
  updater  = updater + CommandHandler( name_, handler_ )
}

AddCallbackHandler = function( handler_ )
{
  handler_ = AddLog( handler_, "CallbackHandler" )
  updater  = updater + CallbackQueryHandler( callback = handler_ )
}

AddMessageHandler = function( handler_ )
{
  handler_ = AddLog( handler_, "MessageHandler" )
  updater  = updater + MessageHandler( handler_ )
}

GenericReturn = function( bot_, user_, menu_, board_, selected_ )
{
  chat_menu = menu_( user_ )

  expr_fun = function()
  {
    bot_$deleteMessage( chat_id = user_$telegram_id, user_$current_message )
  }

  error_fun = function( error_condition )
  {
    lang          = "es"
    response_text = locale_manager$GetText( "Error", lang )
    response_text = paste0( response_text, ": ", error_condition )
    response_text = paste0( response_text, "\nid: ", user_$current_message )

    bot_$sendMessage( chat_id = user_$telegram_id, text = response_text, parse_mode = "html" )
  }

  if( user_$current_message != "" )
    tryCatch( { expr_fun() }, error = error_fun )

  msg = chat_menu$SendMenu( bot_, user_$telegram_id )

  user_$current_message = as.character( msg$message_id )
  user_$CreateDocument()
}

GetCurrentTimeVector = AddLog( GetCurrentTimeVector, "GetCurrentTimeVector" )
GenerateUniqueID     = AddLog( GenerateUniqueID    , "GenerateUniqueID"     )
GetLanguage          = AddLog( GetLanguage         , "GetLanguage"          )
GetChatID            = AddLog( GetChatID           , "GetChatID"            )
AddCommandHandler    = AddLog( AddCommandHandler   , "AddCommandHandler"    )
