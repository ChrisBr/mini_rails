require 'rulers'
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "models")

module Blog
  class Application < Rulers::Application
    puts "Starting application ..."
  end
end
