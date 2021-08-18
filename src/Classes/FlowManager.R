flow_manager_methods = list()
flow_manager_fields  = list()

flow_manager_fields$callbacks = "list"
flow_manager_fields$handlers  = "list"

flow_manager_methods$AddCallback = function( board_, select_, name_ )
{
  function_   = match.fun( name_ )
  function_id = paste( board_, select_, sep = "_" )
  function_id = paste( name_, function_id )
  
  callbacks[[board_]][[select_]] <<- AddLog( function_, function_id )
}

flow_manager_methods$AddHandler = function( board_, select_, name_ )
{
  function_   = match.fun( name_ )
  function_id = paste( board_, select_, sep = "_" )
  function_id = paste( name_, function_id )
  
  handlers[[board_]][[select_]] <<- AddLog( function_, function_id )
}

flow_manager_methods$initialize = function( ... )
{
  callbacks <<- list( list() )
  handlers  <<- list( list() )

  callbacks[["0"]][["0"]] <<- function( x ) x
  handlers[["0"]][["0"]]  <<- function( x ) x
}

class_   = "FlowManager"
super_   = "TraceableObject"
methods_ = flow_manager_methods
fields_  = flow_manager_fields

FlowManager = CreateTraceableClass( class_, super_, methods_, fields_ )
