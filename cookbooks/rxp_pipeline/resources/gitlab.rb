require 'gitlab'
require 'securerandom'


property :host, String
property :post_data,  :kind_of => Hash


action :setup do
  Chef::Log.debug("Calling (POST) %{host}")
  response = doPost(host,post_data)
  token = response['private_token']
  proj_name=SecureRandom.hex

  Gitlab.configure do |config|
    config.endpoint       = 'http://localhost:10080/api/v3'
    config.private_token  = token
  end

  begin
    group=Gitlab.client.create_group(proj_name,proj_name,{})
    project=Gitlab.client.create_project(proj_name,{})
    [{:name=>proj_name,:key=>"adasd"}].each do |user|
      Chef::Log.debug("Creating #{user[:name]} for #{proj_name}")
      email="#{proj_name}@x.org".to_s
      userObj=Gitlab.client.create_user(email, 'password', "#{user[:name]}", { name: 'Demo User' })
      Gitlab.client.add_group_member(group.id, userObj.id, 40)
      Gitlab.client.transfer_project_to_group(group.id,project.id)
    end
    Chef::Log.debug("Group #{group.id}")
  rescue
    Chef::Log.debug("Move on #{$!}")
  end

end

def doPost(_host,_post_data)
  url = _host
  uri = URI(url)
  Chef::Log.debug(uri.path)

  req = Net::HTTP::Post.new(uri.path)
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    Chef::Log.debug(req)
    req.set_form_data(_post_data)
    Chef::Log.debug("sending req =  #{req}")
    http.request(req)
  end
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    #create groups
    Chef::Log.debug("Response=#{res.body}")
    jsonObj=JSON.parse(res.body)
    return jsonObj
  else
    res.value
  end
end
