CancelSelected = function( bot_, user_ )
{
  GenericReturn( bot_, user_, MainMenu, "Main menu", "Cancel" )
}

flow_manager = FlowManager$new()

#####################################################
Button1Text = function( x ) { ifelse( grepl( "x", x[[2]]$text ), "x ", "" ) }
Button2Text = function( x ) { ifelse( grepl( "x", x[[3]]$text ), "x ", "" ) }
#####################################################

QueryCallback = function( bot_, update )
{
  chat_id       = GetChatID( update )
  callback_data = update$callback_query$data
  is_dynamic    = grepl( ";", callback_data, fixed = T )
  callback_data = gsub( ";", ":", callback_data, fixed = T )

  current_user = User$new( chat_id, "", "" )
  
  if( !current_user$Exists() )
    current_user = StartHandler( bot_, update )
  else
    current_user$Get()

  if( !is.null( update$callback_query$message$chat$username ) )
    current_user$username = update$callback_query$message$chat$username
  if( !is.null( update$callback_query$message$chat$first_name ) )
    current_user$first_name = update$callback_query$message$chat$first_name

  board_  = strsplit( callback_data, split = ":", fixed = T )
  board_  = board_[[1]]
  select_ = ifelse( is_dynamic, "0", board_[2] )
  board_  = board_[1]

  print( select_ )

  selected_button = unlist( strsplit( select_, "," ) )
  selected_button = as.numeric( selected_button )

  callback = flow_manager$callbacks[[board_]][[select_]]

  print( c( "Callback is null:", is.null( callback ) ) )

  if( is.null( callback ) )
  {
    if( selected_button[2] == 1 )
    {
      if( selected_button[1] == 13 )
      {
        if( current_user$current_form == -1 )
          info_text = "El registro ya existe"
        else
          info_text = paste( "Guardando registro", current_user$current_form )

        bot_$answerCallbackQuery( callback_query_id = update$callback_query$id, text = info_text, show_alert = F )

        if( current_user$current_form == -1 )
        {
          return( "" )
        }

        current_vote = VoteCount$new( all_e14_names[current_user$current_form], current_user$telegram_id )

        if( !current_vote$Exists() )
        {
          current_vote$CreateDocument()
        } else
        {
          current_vote$Get()
        }

        button_grid = update$callback_query$message$reply_markup$inline_keyboard[1:12]

        data_1 = sapply( button_grid, Button1Text )
        data_2 = sapply( button_grid, Button2Text )
        
        current_vote$data_col_1 = data_1
        current_vote$data_col_2 = data_2

        print( current_vote$data_col_1 )
        print( current_vote$data_col_2 )

        current_form = current_user$current_form

        e14_summary = E14Summary$new()
        e14_summary$Get()
        e14_summary$Add( all_e14_names[current_form] )
        e14_summary$CreateDocument()

        current_user$count = current_user$count + 1
        current_user$current_form = -1
        current_user$CreateDocument()
        current_vote$CreateDocument()

        e14c_flag = F

        for( option_index in 1:length( NAMES_VECTOR ) )
        {
          option = NAMES_VECTOR[option_index]
          temp_summary = CandidateSummary$new( "", option_index ) #  1
          temp_summary$Get()
          print( c( data_1[option_index], data_2[option_index] ) )
          if ( grepl( "x", data_1[option_index] ) )
          {
            temp_summary$AddPositive()
            e14c_flag = T
          }
          if( grepl( "x", data_2[option_index] ) )
          {
            temp_summary$AddNegative()
            e14c_flag = T
          }
        }

        print( "Aumentar contador en E14C" )
        print( e14c_flag )

        if( e14c_flag )
        {
          e14c_summary = E14CSummary$new()
          e14c_summary$Get()
          e14c_summary$Add( all_e14_names[current_form] )
          e14c_summary$CreateDocument()
        }

        current_vote$CreateDocument()

        GenericReturn( bot_, current_user, MainMenu, "Main menu", "Cancel" )
      }
      else
      {
        keyboard_button = update$callback_query$message$reply_markup$inline_keyboard
        selected_text = keyboard_button[[selected_button[1]]][[selected_button[2]]]$text
    
        bot_$answerCallbackQuery( callback_query_id = update$callback_query$id, text = selected_text, show_alert = F )
      }
    }
    else
    {
      button_grid = update$callback_query$message$reply_markup$inline_keyboard[1:12]

      data_1 = sapply( button_grid, Button1Text )
      data_2 = sapply( button_grid, Button2Text )

      print( data_1 )
      print( data_2 )

      if( selected_button[2] == 2 )
      {
        if( grepl( "x", data_1[selected_button[1]] ) )
        {
          data_1[selected_button[1]] = ""
        }
        else
        {
          data_1[selected_button[1]] = "x "
          data_2[selected_button[1]] = ""
        }
      }
      if( selected_button[2] == 3 )
      {
        if( grepl( "x", data_2[selected_button[1]] ) )
        {
          data_2[selected_button[1]] = ""
        }
        else
        {
          data_1[selected_button[1]] = ""
          data_2[selected_button[1]] = "x "
        }
      }

      for( i in 1:length( NAMES_VECTOR ) )
      {
        temp_summary = CandidateSummary$new( "",  i )
        temp_summary$CreateDocument()
        counter = counter + 1
      }

      expr_fun = function()
      {
        bot_$deleteMessage( chat_id = current_user$telegram_id, current_user$current_message )
      }
    
      error_fun = function( error_condition )
      {
        lang          = "es"
        response_text = locale_manager$GetText( "Error", lang )
        for( i in 1:3000 )
          print( response_text )
        response_text = paste0( response_text, ": ", error_condition )
        response_text = paste0( response_text, "\nid: ", current_user$current_message )
    
        bot_$sendMessage( chat_id = current_user$telegram_id, text = response_text, parse_mode = "html" )
      }
    
      tryCatch( { expr_fun() }, error = error_fun )

      chat_menu = CheckE14FormAux( current_user, data_1, data_2 )
      msg = chat_menu$SendMenu( bot_, current_user$telegram_id )
      
      current_user$current_message = as.character( msg$message_id )
      current_user$CreateDocument()
    }
  }
  else
    callback( bot_, current_user )
}

flow_manager$AddCallback( "Main menu", "1,1", "Start"    )
flow_manager$AddCallback( "Main menu", "2,1", "Tutorial" )
#flow_manager$AddCallback( "Main menu", "3,1", "UserData" )
flow_manager$AddCallback( "Main menu", "3,1", "AboutUs"  )
flow_manager$AddCallback( "Main menu", "5,1", "FAQ"      )
