require './config/application'
require './middlewares/delta_logger'

use DeltaLogger
run BestQuotes::Application.new
