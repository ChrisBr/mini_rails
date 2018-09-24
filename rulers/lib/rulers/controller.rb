require 'erubis'
require "rack/request"

module Rulers
  class Controller
    def initialize(env)
      @env = env
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      send(action)
      render(action) unless response
      st, hd, rs = response.to_a

      [st, hd, [rs.body].flatten]
    end

    def self.action(action, routing_params = {})
      proc { |env| self.new(env).dispatch(action, routing_params) }
    end

    def params
      request.params.merge @routing_params
    end

    def call(env)
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def response
      @response
    end

    def render(*args)
      create_response(body(*args))
    end

    private

    def create_response(text, status = 200, headers = {})
      raise 'Already responded' if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def body(view_name, locals = {})
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(instance_variables_to_hash)
    end

    def instance_variables_to_hash
      instance_variables.map{ |variable| [variable, instance_variable_get(variable)] }.to_h
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, '')
      klass = klass.underscore
    end
  end
end
