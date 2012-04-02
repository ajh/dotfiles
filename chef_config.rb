cookbook_path File.join(File.absolute_path(File.dirname(__FILE__)), 'cookbooks')

cache_options(:path => "#{ENV['HOME']}/.chef/checksums")

file_backup_path "#{ENV['HOME']}/.chef/backup"
file_cache_path "#{ENV['HOME']}/.chef/cache"
sandbox_path "#{ENV['HOME']}/.chef/sandboxes"
