root = "/home/shwbai/rails/sonkwo_community_ng/"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.sonkwo_community_ng.sock"
worker_processes 2
timeout 30
