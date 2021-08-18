MainMenu = function( user_ )
{
  chat_menu  = ChatMenu$new( "Main menu" )
  lang       = "es"
  split_name = SplitName( user_$first_name )
  
  start_text     = locale_manager$GetText( "StartProcess", lang )
  tutorial_text  = locale_manager$GetText( "Tutorial"    , lang )
  user_info_text = locale_manager$GetText( "ViewUserInfo", lang )
  about_text     = locale_manager$GetText( "AboutUs"     , lang )
  web_link_text  = locale_manager$GetText( "WebApp"      , lang )
  
  chat_menu$AddText( start_text    , 1 )
  chat_menu$AddText( tutorial_text , 1 )
#  chat_menu$AddText( user_info_text, 1 )
  chat_menu$AddText( about_text    , 1 )

#  chat_menu$AddLink( text_ = web_link_text, link_ = "azazelspce.github.io/e14", column_ = 1 )

  chat_menu$chat_text = locale_manager$GetText( "Hi", lang )
  chat_menu$chat_text = paste( chat_menu$chat_text, split_name, sep = " " )
  chat_menu$chat_text = paste( chat_menu$chat_text, locale_manager$GetText( "ChooseOption", lang ), sep = ". " )
  
  return( chat_menu )
}

CheckE14Form = function( user_ )
{
  data_1 = c( "", "", "", "", "", "", "", "", "", "", "", "" )
  data_2 = c( "", "", "", "", "", "", "", "", "", "", "", "" )

  return( CheckE14FormAux( user_, data_1, data_2 ) )
}

CheckE14FormAux = function( user_, data_1_, data_2_ )
{
  chat_menu  = ChatMenu$new( "Check E14 Form" )
  lang       = "es"
  
  petro_text        = locale_manager$GetText( "Petro"     , lang ) #  1
  promotores_text   = locale_manager$GetText( "Promotores", lang ) #  2
  disque_text       = locale_manager$GetText( "Duque"     , lang ) #  3
  street_text       = locale_manager$GetText( "Calle"     , lang ) #  4
  tufillo_text      = locale_manager$GetText( "Trujillo"  , lang ) #  5
  jajardo_text      = locale_manager$GetText( "Fajardo"   , lang ) #  6
  babosa_text       = locale_manager$GetText( "Viviane"   , lang ) #  7
  mocho_text        = locale_manager$GetText( "Lleras"    , lang ) #  8
  blanco_text       = locale_manager$GetText( "Blanco"    , lang ) #  9
  nulos_text        = locale_manager$GetText( "Nulos"     , lang ) # 10
  no_marcados_text  = locale_manager$GetText( "NoMarcados", lang ) # 11
  total_text        = locale_manager$GetText( "Total"     , lang ) # 12
  
  chat_menu$AddText( petro_text      , 1 )
  chat_menu$AddText( promotores_text , 1 )
  chat_menu$AddText( disque_text     , 1 )
  chat_menu$AddText( street_text     , 1 )
  chat_menu$AddText( tufillo_text    , 1 )
  chat_menu$AddText( jajardo_text    , 1 )
  chat_menu$AddText( babosa_text     , 1 )
  chat_menu$AddText( mocho_text      , 1 )
  chat_menu$AddText( blanco_text     , 1 )
  chat_menu$AddText( nulos_text      , 1 )
  chat_menu$AddText( no_marcados_text, 1 )
  chat_menu$AddText( total_text      , 1 )
  chat_menu$AddText( "Confirmar"     , 1 )

  chat_menu$AddText( paste0( data_1_[ 1], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 2], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 3], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 4], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 5], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 6], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 7], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 8], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[ 9], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[10], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[11], "Suma" ), 2 )
  chat_menu$AddText( paste0( data_1_[12], "Suma" ), 2 )

  chat_menu$AddText( paste0( data_2_[ 1], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 2], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 3], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 4], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 5], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 6], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 7], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 8], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[ 9], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[10], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[11], "Resta" ), 3 )
  chat_menu$AddText( paste0( data_2_[12], "Resta" ), 3 )

  chat_menu$chat_text = locale_manager$GetText( "ChooseCandidate", lang )
  
  return( chat_menu )
}

CreateTextSheet = function( response )
{
  values    = response$value$values
  values    = sapply( values, function( x ) as.logical( x$stringValue ) )
  responses = response$response$values
  responses = sapply( responses, function( x ) x$stringValue )

  score_percentage = sum( values ) / length( values )
  score_percentage = round( score_percentage * 100, digits = 2 )
  score_percentage = paste( "Score:", score_percentage, "/ 100\n" )
  
  response_sheet = c( score_percentage )
  
  for( index in 1:length( response$response$values ) )
  {
    string_number  = as.character( index )
    number_length  = nchar( string_number )
    string_number  = c( rep( 0, 3 - number_length ), string_number, " | " )
    string_number  = paste( string_number, collapse = "" )
    response_sheet = c( response_sheet, string_number )
    
    for( line_text in 1:max( responses ) )
    {
      check_flag  = line_text == responses[index]
      check_value = ifelse( check_flag, checkbox_states[3], checkbox_states[1] )
      response_sheet = c( response_sheet, check_value )
    }
    
    response_sheet = c( response_sheet, "\n" )
  }
  
  response_sheet = paste( response_sheet, collapse = " " )
  
  return( response_sheet )
}

ShowResults = function( user_ )
{
  chat_menu  = ChatMenu$new( "Results" )
  lang       = user_$language
  split_name = SplitName( user_$first_name )

  response    = Response$new( user_$id, )
  
  response$Get()
  
  chat_menu$chat_text = CreateTextSheet( response )
  chat_menu$chat_text = paste( split_name, chat_menu$chat_text, sep = ", " )
  
  return( chat_menu )
}

MainMenu        = AddLog( MainMenu       , "MainMenu"        )
CreateTextSheet = AddLog( CreateTextSheet, "CreateTextSheet" )
ShowResults     = AddLog( ShowResults    , "ShowResults"     )
