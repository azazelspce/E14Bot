candidate_summary_fields                = list()
candidate_summary_fields$positive_count = "numeric"
candidate_summary_fields$negative_count = "numeric"
candidate_summary_fields$id             = "numeric"
candidate_summary_fields$name           = "character"

candidate_summary_methods = list()

candidate_summary_methods$GetPath = function()
{
  return( "documents/Summary" )
}

candidate_summary_methods$GetBody = function()
{
  body_ = list()
  
  body_$positive_count = positive_count
  body_$negative_count = negative_count
  body_$id             = id
  body_$name           = name
  return( body_ )
}

candidate_summary_methods$Get = function()
{
  if( Exists() )
  {
    result = jsonlite::fromJSON( readLines( CreateURL( FALSE ) ) )

    positive_count <<- result$positive_count
    negative_count <<- result$negative_count
    id             <<- result$id
    name           <<- result$name

    return( "candidate summary loaded" )
  }
}

candidate_summary_methods$AddPositive = function()
{
  positive_count <<- positive_count + 1
  return( positive_count )
}

candidate_summary_methods$AddNegative = function()
{
  negative_count <<- negative_count + 1
  return( negative_count )
}

candidate_summary_methods$GetID = function()
{
  return( paste( "Candidate_", id, ".txt", sep = "" ) )
}

candidate_summary_methods$initialize = function( name, id, ... )
{
  positive_count <<- 0
  negative_count <<- 0
  id             <<- id
  name           <<- name

  callSuper( ... )
}

class_   = "CandidateSummary"
super_   = "FileObject"
methods_ = candidate_summary_methods
fields_  = candidate_summary_fields

CandidateSummary = CreateTraceableClass( class_, super_, methods_, fields_ )
