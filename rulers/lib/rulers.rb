require "rulers/version"
require "rulers/core_extensions/string"
require "rulers/routing"
require "rulers/dependencies"
require "rulers/controller"
require "rulers/model/sqlite"
require "rulers/routing/route_object"

module Rulers
  class Application
    def route(&block)
      @route_object ||= Routing::RouteObject.new
      @route_object.instance_eval(&block)
    end

    def call(env)
      get_rack_app(env).call(env)
    rescue
      [404, {}, ["Not found!"]]
    end

    def get_rack_app(env)
      raise "No routes" unless @route_object
      @route_object.check_url env['PATH_INFO']
    end
  end
end
