StartHandler = function( bot_, update_ )
{
  lang       = GetLanguage( update_ )
  chat_id    = GetChatID( update_ )
  first_name = GetFirstName( update_ )
  username   = GetUsername( update_ )

  if( is.null( update_$message$from$first_name ) )
    update_$message$from$first_name = ""
  if( is.null( update_$message$from$username ) )
    update_$message$from$username = ""

  current_user = User$new( chat_id, first_name, username )
  
  current_user$first_name  = update_$message$from$first_name
  current_user$username    = update_$message$from$username
  current_user$telegram_id = chat_id

  if( !current_user$Exists() )
  {
    print( current_user$CreateDocument() )
  } else
  {
    print( current_user$Get() )
  }

  chat_menu = MainMenu( current_user )
  msg = chat_menu$SendMenu( bot_, chat_id )
  
  current_user$current_message = as.character( msg$message_id )
  current_user$CreateDocument()
  
  return( current_user )
}

BaseMessageHandler = function( bot_, update )
{
  chat_id = GetChatID( update )
}

flow_manager$AddHandler( "Set data", "First name", "FirstNameEntered" )
