SetLanguage = function( bot_, user_, actions_, lang )
{
  user_$language = lang
  
  GenericReturn( bot_, user_, actions_, MainMenu, "Lang select", lang )
  
  user_$CreateDocument()
}

SetLanguage = AddLog( SetLanguage, "SetLanguage" )

SpanishSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "Español" )
}

EnglishSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "English" )
}

PortugueseSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "Português" )
}

GermanSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "Deutsch" )
}

FrenchSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "Français" )
}

JapaneseSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "日本語" )
}

RussianSelected = function( bot_, user_, actions_ )
{
  SetLanguage( bot_, user_, actions_, "русский" )
}
