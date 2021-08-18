vote_count_fields            = list()
vote_count_fields$form_id    = "character"
vote_count_fields$user_id    = "character"
vote_count_fields$finished   = "logical"
vote_count_fields$data_col_1 = "character"
vote_count_fields$data_col_2 = "character"

vote_count_methods = list()

vote_count_methods$GetPath = function()
{
  return( "documents/FormE14" )
}

vote_count_methods$GetBody = function()
{
  body_ = list()
  
  body_$form_id    = form_id
  body_$user_id    = user_id
  body_$finished   = finished
  body_$data_col_1 = data_col_1
  body_$data_col_2 = data_col_2
  
  return( body_ )
}

vote_count_methods$Get = function()
{
  if( Exists() )
  {
    result = jsonlite::fromJSON( readLines( CreateURL( FALSE ) ) )

    form_id    <<- result$form_id
    user_id    <<- result$user_id
    finished   <<- result$finished
    data_col_1 <<- result$data_col_1
    data_col_2 <<- result$data_col_2

    return( "Vote loaded" )
  }
}

vote_count_methods$GetID = function()
{
  return( paste( form_id, user_id, sep = "/" ) )
}

vote_count_methods$initialize = function( form_id_, user_id_, ... )
{
  form_id    <<- form_id_
  user_id    <<- user_id_
  finished   <<- FALSE
  data_col_1 <<- ""
  data_col_2 <<- ""

  callSuper( ... )
}

class_   = "VoteCount"
super_   = "FileObject"
methods_ = vote_count_methods
fields_  = vote_count_fields

VoteCount = CreateTraceableClass( class_, super_, methods_, fields_ )
