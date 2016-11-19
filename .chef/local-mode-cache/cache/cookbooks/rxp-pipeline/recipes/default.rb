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
    echo 'docker restore or what not'
  EOH
end

bash 'start pipeline' do
  code <<-EOH
    docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home ci/jenkins
  EOH
end

rxp-pipline_wait 'wait for server' do
  host 'http://localhost:8080'
  action :wait_on
end






