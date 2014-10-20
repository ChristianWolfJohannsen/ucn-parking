# config/unicorn.rb
worker_processes Integer(ENV['WEB_CONCURRENCY'] || 5)
timeout 15
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    logger.debug 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    logger.debug 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
