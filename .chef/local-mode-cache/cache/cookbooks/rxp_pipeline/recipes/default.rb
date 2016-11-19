#
# Cookbook Name:: rxp-pipeline
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

bash 'restore volume' do
  code <<-EOH
    #docker create -v /data/jenkins-ci/ --name jenkins_home-chef busybox true
    #sudo docker run --rm --volumes-from jenkins_home-chef -v $(pwd):/backup busybox tar xvf /backup/backup.tar
  EOH
end

bash 'start pipeline' do
  cwd ::File.dirname(node["pipeline"]["docker_file"])
  code <<-EOH
    docker-compose up &
  EOH
  not_if do ::File.exist?('/var/run/docker.sock') end
end

node["pipeline"]["services"].each do |svc|
  rxp_pipeline_wait 'wait on' do
    host svc
    action :wait_on
  end
end


ruby_block "Init Time" do
  block do
    puts "Ready"
  end
end







