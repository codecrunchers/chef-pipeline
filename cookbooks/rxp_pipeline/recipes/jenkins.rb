
chef_gem 'jenkins_api_client'
require 'jenkins_api_client'


template '/tmp/project.xml' do
  source 'jenkins/jenkins.job.erb'
  variables(
    :PROJECT_NAME => node['pipeline']['project_name']
  )

end

ruby_block 'create job' do
  block do
    #project_xml = File.new("/tmp/project.xml")
    @client = JenkinsApi::Client.new(:server_ip => '127.0.0.1', :server_port => '8080')
    open("/tmp/project.xml") {|f|
      data = f.read # This returns a string even if the file is empty.
      @client.job.create(node['pipeline']['project_name'],data)
    }
  end
end


