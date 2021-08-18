UpdateDataEntered = function( bot_, user_, actions_ )
{
  actions_$input = ""
  
  GenericReturn( bot_, user_, actions_, SetupData, "Set data", "" )
  
  user_$CreateDocument()
}

FirstNameEntered = function( bot_, current_user, actions_ )
{
  current_user$first_name = actions_$input

  UpdateDataEntered( bot_, current_user, actions_ )
}
