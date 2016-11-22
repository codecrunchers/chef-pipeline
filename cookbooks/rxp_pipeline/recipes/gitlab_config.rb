require 'net/http'
require 'json'


rxp_pipeline_gitlab "Init GitLab" do
    host "#{node['pipeline']['gitlab_url']}/session"
    post_data ({'login'=>'root', 'password' => 'password'})
    action :setup
end






