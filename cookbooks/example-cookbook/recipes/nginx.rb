#
# Cookbook Name:: chef-docker-rails-example
# Recipe::nginx-run
#

include_recipe 'docker'

remote_directory '/tmp/nginx' do
  source 'nginx'
end

docker_image 'austenito' do
  source '/tmp/nginx'
  tag 'nginx'
  action :build_if_missing
  cmd_timeout 900
end

if `sudo docker ps -a | grep nginx`.size > 0
  execute('stop container') { command "docker stop -t 60 nginx" }
  execute('remove container') { command "docker rm -f nginx" }
end

docker_container 'nginx' do
  image 'austenito:nginx'
  container_name 'nginx'
  port "80:80"
  link ['rails-example:rails_example']
  volumes_from 'gem-cache'
  detach true
  action :run
end
