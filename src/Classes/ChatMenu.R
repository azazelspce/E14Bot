menu_methods = list()
menu_fields  = list()

menu_fields$board        = "character"
menu_fields$buttons      = "list"
menu_fields$current_size = "list"
menu_fields$chat_text    = "character"

menu_methods$AddText = function( text_, column_ = 1 )
{
  AddLink( text_ = text_, column_ = column_ )
}

menu_methods$AddLink = function( text_, link_, data_, dynamic_ = F, column_ = 1 )
{
  current_size[[column_]] <<- current_size[[column_]] + 1
  
  if( length( buttons ) < current_size[[column_]] )
  {
    buttons[[current_size[[column_]]]] <<- list()
  }
  
  if( missing( data_ ) )
  {
    index_str = paste( current_size[[column_]], column_, sep = "," )
    data_     = paste( board, index_str                , sep = ":" )
  } else
  {
    if( dynamic_ )
    {
      data_ = paste( board, data_, sep = ";" )
    } else
    {
      data_ = paste( board, data_, sep = ":" )
    }
  }
  
  if( missing( link_ ) )
    temp_ = InlineKeyboardButton( text_, callback_data = data_ )
  else
    temp_ = InlineKeyboardButton( text_, url = link_ )
  
  buttons[[current_size[[column_]]]][[column_]] <<- temp_
  
  ikm = InlineKeyboardMarkup( inline_keyboard = buttons )
  
  return( ikm )
}

menu_methods$AddData = function( text_, data_, dynamic_, column_ = 1 )
{
  AddLink( text_ = text_, data_ = data_, column_ = column_, dynamic = dynamic_ )
}

menu_methods$SendMenu = function( bot_, id_ )
{
  ikm = InlineKeyboardMarkup( inline_keyboard = buttons )
  msg = bot_$sendMessage( chat_id = id_, text = chat_text, reply_markup = ikm, parse_mode = "html" )
  
  return( msg )
}

menu_methods$UpdateMenu = function( bot_, id )
{
  ikm = InlineKeyboardMarkup( inline_keyboard = buttons )
  
  bot_$editMessageText( id, message_id, text = chat_text, reply_markup = ikm )
}

menu_methods$initialize = function( board_, ... )
{
  board        <<- board_
  buttons      <<- list( list() )
  current_size <<- list( 0, 0, 0, 0, 0, 0, 0, 0 )
  chat_text    <<- ""
}

class_   = "ChatMenu"
super_   = "TraceableObject"
methods_ = menu_methods
fields_  = menu_fields

ChatMenu = setRefClass( class_, contains = super_, methods = methods_, fields = fields_ )
