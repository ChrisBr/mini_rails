class DeltaLogger
  def initialize(app)
    @app = app
  end
  
  def call(env)
    start_time = Time.now
    status, headers, content = @app.call(env)
    end_time = Time.now
    STDOUT.write("==========================\n")
    STDOUT.write("Time Delta: #{end_time - start_time}\n")
    STDOUT.write("==========================\n")
    [
      status, headers, content
    ]
  end
end
