require './config/application'
require './middlewares/delta_logger'

use DeltaLogger

app = Blog::Application.new
use Rack::ContentType

app.route do
  root "articles#index"
  match "sub-app", proc { [200, {}, ["Hello, sub-app!"]] }
  # default routes
  match ":controller/:id/:action"
  match ":controller/:id", :default => { "action" => "show" }
  match ":controller", :default => { "action" => "index" }
end

run app
