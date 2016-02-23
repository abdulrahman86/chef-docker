#
# Cookbook Name:: example-cookbook
# Recipe:: rails-example
#

include_recipe 'docker'

remote_directory '/tmp/rails-example' do
  source 'rails-example'
end

docker_image 'austenito/rails-example' do
  source '/tmp/rails-example'
  action :build_if_missing
  cmd_timeout 900
end

if `sudo docker ps -a | grep rails-example`.size > 0
  execute('stop container') { command "docker stop -t 60 rails-example" }
  execute('remove container') { command "docker rm -f rails-example" }
end

docker_container 'rails-example' do
  image 'austenito/rails-example'
  container_name 'rails-example'
  detach true
  link ['postgres:db']
  volumes_from 'gem-cache'
  action :run
  port '3000:3000'
end
