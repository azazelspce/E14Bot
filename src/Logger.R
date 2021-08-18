FromEnv = function()
{
  return( "Environment" )
}

AddLog = function( function_ref, function_name, from = "FromEnv()" )
{
  full_body = as.character( body( function_ref ) )
  full_body = gsub( "return(", ";cat( message_text___ );return(", full_body, fixed = T )
  temp_body = full_body[-c( 1, length( full_body ) )]
  temp_body = paste( temp_body, collapse = ";" )

  formal_args = formalArgs( function_ref )
  
  temp_function = "function(){ message_text___ = date();"
  
  if( !is.null( formal_args ) )
  {
    formal_args = paste( formal_args, collapse = "," )
    temp_function = "function("
    temp_function = paste( temp_function, formal_args )
    temp_function = paste( temp_function, "){ message_text___ = date();" )
  }
  
  if( !any( grepl( ".*return.*", full_body ) ) )
  {
    temp_l = paste( "cat( message_text___ );", full_body[length( full_body )] )
    full_body[length( full_body )] = temp_l
  }

  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___, " )
  temp_function = paste( temp_function, "\"Start function" )
  temp_function = paste( temp_function, function_name )
  temp_function = paste( temp_function, "from class\");" )
  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___," )
  temp_function = paste( temp_function, from )
  temp_function = paste( temp_function, ");" )
  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___, " )
  temp_function = paste( temp_function, "\"\n\" );" )
  temp_function = paste( temp_function, "cat( message_text___ );" )
  temp_function = paste( temp_function, "message_text___ = date();" )
  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___, " )
  temp_function = paste( temp_function, "\"End function" )
  temp_function = paste( temp_function, function_name )
  temp_function = paste( temp_function, "from class\");" )
  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___," )
  temp_function = paste( temp_function, from )
  temp_function = paste( temp_function, ");" )
  temp_function = paste( temp_function, "message_text___ = paste(" )
  temp_function = paste( temp_function, "message_text___, " )
  temp_function = paste( temp_function, "\"\n\" );" )
  temp_function = paste( temp_function, temp_body )
  temp_function = paste( temp_function, ";" )
  temp_function = paste( temp_function, full_body[length( full_body )] )
  temp_function = paste( temp_function, "}" )

  result = eval( parse( text = temp_function ) )
  
  return( result )
}

AddLogList = function( functions )
{
  result  = list()
  
  for( index in 1:length( functions ) )
  {
    function_ref  = functions[[index]]
    function_name = names( functions )[index]
    temp_result   = AddLog( function_ref, function_name, "GetClass()" )
    
    result[[index]] = temp_result
  }

  names( result ) = names( functions )
  
  return( result )
}
