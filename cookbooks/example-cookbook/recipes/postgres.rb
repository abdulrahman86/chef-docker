#
# Cookbook Name:: example-cookbook
# Recipe:: postgres-run
#


include_recipe 'docker'

remote_directory '/tmp/postgres' do
  source 'postgres'
end

docker_image 'austenito/postgres' do
  source '/tmp/postgres'
  tag '9.3'
  action :build_if_missing
  cmd_timeout 900
end

if `sudo docker ps -a | grep postgres`.size == 0
  docker_container 'postgres' do
    image 'austenito/postgres:9.3'
    container_name 'postgres'
    port "5432:5432"
    detach true
    env ["POSTGRES_USER=#{node['postgresql']['user']}",
         "POSTGRES_PASSWORD=#{node['postgresql']['password']}"
        ]
    volumes_from 'gem-cache'
    action :run
  end
end

