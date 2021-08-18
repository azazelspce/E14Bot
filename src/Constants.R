locale_manager = LocaleManager$new()

telegram_url    = "https://api.telegram.org/file/bot"
telegraph_url   = "https://api.telegra.ph"

node_command = "node dependencies/MarkdownToNodes.js"

checkbox_states = c( "\xE2\x98\x90" , "\xF0\x9F\x97\xB5", "\xF0\x9F\x97\xB5" )
checkbox_states = c( checkbox_states, "\xF0\x9F\x97\xB9" )

locale_manager$AddLanguage( "English"  , "locales/en" )
locale_manager$AddLanguage( "Español"  , "locales/es" )

locale_manager$SetDefaultLanguage( "Español" )
