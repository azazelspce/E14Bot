NotImplemented = function()
{
  print( match.call() )
  stop( "Function not implemented" )
}

base_object_methods = list()

base_object_methods$GetClass = function()
{
  return( getClass()@className[1] )
}

BaseObject = setRefClass( "BaseObject", methods = base_object_methods )
