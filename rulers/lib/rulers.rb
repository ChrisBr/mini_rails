require "rulers/version"
require "rulers/core_extensions/string"
require "rulers/routing"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/model/sqlite"

module Rulers
  class Application
    def call(env)
      if env['PATH_INFO'] == '/'
        return [200, { 'Content-Type' => 'text/html'}, ['Hello from Rulers!']]
      elsif env['PATH_INFO'] == '/favicon.ico'
        return [404, { 'Content-Type' => 'text/html'}, []]
      end
      klass, action = get_controller_and_action(env)
      action = klass.action(action)
      action.call(env)
    end
  end
end
