E14C_summary_fields         = list()
E14C_summary_fields$count   = "numeric"
E14C_summary_fields$E14List = "list"

E14C_summary_methods = list()

E14C_summary_methods$GetPath = function()
{
  return( "documents/Summary" )
}

E14C_summary_methods$GetBody = function()
{
  body_ = list()
  
  body_$count   = count
  body_$E14List = E14List

  return( body_ )
}

E14C_summary_methods$Get = function()
{
  if( Exists() )
  {
    result = jsonlite::fromJSON( readLines( CreateURL( FALSE ) ) )

    count   <<- result$count
    E14List <<- result$E14List

    return( "E14C summary loaded" )
  }
}

E14C_summary_methods$GetID = function()
{
  return( "E14CSummary.txt" )
}

E14C_summary_methods$Add = function( E14_id )
{
  count <<- count + 1
  if( E14_id %in% names( E14List ) )
  {
    E14List[[E14_id]] <<- E14List[[E14_id]] + 1
  }
  else
  {
    E14List[[E14_id]] <<- 1
  }

  return( count )
}

E14C_summary_methods$initialize = function( ... )
{
  count   <<- 0
  E14List <<- list()

  callSuper( ... )
}

class_   = "E14CSummary"
super_   = "FileObject"
methods_ = E14C_summary_methods
fields_  = E14C_summary_fields

E14CSummary = CreateTraceableClass( class_, super_, methods_, fields_ )
