Start = function( bot_, user_ )
{
  menu_ = CheckE14Form
  index = sample( 1:length( all_e14_full ), 1 )
  print( c( "Selección E14 form", index, "/", length( all_e14_full ) ) )
  print( c( user_$telegram_id, all_e14_full[index] ) )
  download.file( paste0( HOST_IMAGES, all_e14_full[index] ), destfile = "~/FormularioTemp.png" )
  bot_$sendPhoto( user_$telegram_id, photo = "~/FormularioTemp.png", disable_notification = T )

  user_$current_form = index
  user_$CreateDocument()

  current_vote = VoteCount$new( all_e14_names[index], user_$telegram_id )

  print( all_e14_full[index] )
  print( current_vote )
  print( c( all_e14_names[index], user_$telegram_id ) )

  if( !current_vote$Exists() )
  {
    print( current_vote$CreateDocument() )
  } else
  {
    print( current_vote$Get() )
  }

  GenericReturn( bot_, user_, menu_, "Main menu", "Start" )
}

Tutorial = function( bot_, user_ )
{
  print( "UserData" )
  bot_$sendPhoto( user_$telegram_id, photo = "./Resources/Tutorial.png", disable_notification = T )
  GenericReturn( bot_, user_, MainMenu, "Main menu", "Tutorial" )
}

UserData = function( bot_, user_ )
{
  print( "UserData" )
  #menu_ = ExamMenu
  #GenericReturn( bot_, user_, menu_, "Main menu", "Exam select" )
}

AboutUs = function( bot_, user_ )
{
  lang          = "es"
  response_text = locale_manager$GetText( "AADescription", lang )

  msg = bot_$sendMessage( chat_id = user_$telegram_id, text = response_text, parse_mode = "html" )
  
  user_$current_message = as.character( msg$message_id )
  user_$CreateDocument()
  
  #GenericReturn( bot_, user_, MainMenu, "Main menu", "About us" )
}

ToDo = function( bot_, user_ )
{
  lang          = "es"
  response_text = locale_manager$GetText( "ToDo", lang )

  msg = bot_$sendMessage( chat_id = user_$telegram_id, text = response_text, parse_mode = "html" )
  
  user_$current_message = as.character( msg$message_id )
  user_$CreateDocument()

  #GenericReturn( bot_, user_, MainMenu, "Main menu", "To do" )
}

FAQ = function( bot_, user_ )
{
  print( "FAQ" )
  #menu_ = ExamMenu
  #GenericReturn( bot_, user_, menu_, "Main menu", "Exam select" )
}
