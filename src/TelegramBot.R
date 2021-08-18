#!/usr/bin/env Rscript
library( telegram.bot )
library( httr         )

source( "src/Logger.R"                   )
source( "src/Utils.R"                    )
source( "src/Classes/BaseObject.R"       )
source( "src/Classes/TraceableObject.R"  )
source( "src/Classes/LocaleManager.R"    )
source( "src/Constants.R"                )
source( "src/Classes/FileObject.R"       )
source( "src/Classes/User.R"             )
source( "src/Classes/UserActions.R"      )
source( "src/Classes/VoteCount.R"        )
source( "src/Classes/ChatMenu.R"         )
source( "src/Classes/FlowManager.R"      )
source( "src/Classes/CandidateSummary.R" )
source( "src/Classes/E14Summary.R"       )
source( "src/Classes/E14CSummary.R"      )
source( "src/Callbacks/MainMenu.R"       )
source( "src/Callbacks/Callbacks.R"      )
source( "src/Handlers/UpdateData.R"      )
source( "src/Handlers/Handlers.R"        )
source( "src/Boards.R"                   )

args = commandArgs( trailingOnly = TRUE )

if( length( args ) == 0 )
{
  stop( "At least one argument must be supplied.n", call. = FALSE )
}

if( args == "dev" )
{
  chatbot_key   = Sys.getenv( "TEST_CONTEO_E14BOT_KEY" )
  updater       = Updater( token = chatbot_key )
} else
{
  chatbot_key   = Sys.getenv( "CONTEO_E14BOT_KEY" )
  updater       = Updater( token = chatbot_key )
}

HOST_IMAGES = Sys.getenv( "HOST_IMAGES" )

lang = "es"
NAMES_VECTOR = c( "Petro", "Promotores", "Duque", "Calle", "Trujillo", "Fajardo" )
NAMES_VECTOR = c( NAMES_VECTOR, "Viviane", "Lleras", "Blanco", "Nulos", "NoMarcados" )
NAMES_VECTOR = c( NAMES_VECTOR, "Total" )

counter = 1

for( option in NAMES_VECTOR )
{
  name_text = locale_manager$GetText( option, lang )
  temp_summary = CandidateSummary$new( name_text, counter ) #  1
  temp_summary$CreateDocument()
  counter = counter + 1
}

AddCommandHandler( "start", StartHandler )
AddCallbackHandler( QueryCallback )
AddMessageHandler( BaseMessageHandler )

updater$bot$clean_updates()

e14_png_path = "/mnt/Datos/E14/PDF/PNG"

all_e14_names = readLines( "/mnt/Datos/E14/lista_pdfs.txt" )
all_e14_names = gsub( ".*/", "", all_e14_names )
all_e14_full  = gsub( "pdf", "png", all_e14_names )

updater$start_polling()
