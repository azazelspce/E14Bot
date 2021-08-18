CreateTraceableClass = function( class_, contains_, method_list, field_list )
{
  result = NULL
  
  if( missing( method_list ) && missing( field_list ) )
  {
    result = setRefClass( Class = class_, contains = contains_ )
  } else if( missing( method_list ) )
  {
    fields_ = field_list
    result  = setRefClass( Class = class_, contains = contains_, fields = fields_ )
  } else if( missing( field_list ) )
  {
    methods_ = AddLogList( method_list )
    result   = setRefClass( Class = class_, contains = contains_, methods = methods_ )
  } else
  {
    fields_  = field_list
    methods_ = AddLogList( method_list )
    result   = setRefClass( class_, contains = contains_, methods = methods_, fields = fields_ )
  }
  
  return( result )
}

traceable_methods = list()

traceable_methods$Logger = function( text_vector )
{
  if( missing( text_vector ) )
  {
    message_text = "Nothing to log"
    message_text = paste( date(), message_text )
    
    cat( message_text )
    cat( "\n" )
    
    return( message_text )
  }
  
  message_text = paste( text_vector, collapse = " - " )
  message_text = paste( date(), message_text )

  cat( message_text )
  cat( "\n" )
  
  return( message_text )
}

class_ = "TraceableObject"
super_ = "BaseObject"

TraceableObject = CreateTraceableClass( class_, super_, traceable_methods )
