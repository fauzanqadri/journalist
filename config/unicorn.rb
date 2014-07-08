stderr_path "./log/unicorn.log"
stdout_path "./log/unicorn.log"
working_directory "/Volumes/Projects/Ruby/rails/wicket/"
pid "./tmp/pids/unicorn.pids"
listen "/tmp/unicorn.journalist.sock", :backlog => 64

# listen 3000, :tcp_nopush => true

worker_processes 2

timeout 30

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
	GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end


after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end
