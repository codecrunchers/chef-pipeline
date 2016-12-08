require 'jenkins_api_client'
require 'open-uri'
require 'securerandom'

postfx=""
#SecureRandom.hex(10).to_s
proj_name="#{sanitize_filename(node['pipeline']['project_name'])}#{postfx}"
proj_filename = "/tmp/project_#{proj_name}.xml"
Chef::Log.debug("Creating #{proj_name}")


template "#{proj_filename}" do
  source 'jenkins/jenkins.job.erb'
  variables(
    :PROJECT_NAME_GIT =>proj_name,
    :PROJECT_GROUP => proj_name
    ) 
  not_if do ::JenkinsApi::Client.new(:server_ip => '127.0.0.1', :server_port => '18080').job.exists?(proj_name) end
end

ruby_block 'create job' do
  block do
    project_xml = File.new(proj_filename)
    @client = JenkinsApi::Client.new(:server_ip => '127.0.0.1', :server_port => '18080')
    open(project_xml) {|f|
      data = f.read # This returns a string even if the file is empty.
      @client.job.create(proj_name,data)
    }
    Chef::Log.debug("Done Creating #{proj_name}")
  end
  not_if do ::JenkinsApi::Client.new(:server_ip => '127.0.0.1', :server_port => '18080').job.exists?(proj_name) end
end


