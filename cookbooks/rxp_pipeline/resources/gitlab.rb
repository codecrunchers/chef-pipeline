require 'gitlab'
require 'pp'
require 'securerandom'


property :host, String
property :post_data,  :kind_of => Hash

##
# Get a token, 
# create a project, 
# add members to new group, 
# assign group to project
##
action :setup do
  Chef::Log.debug("Calling (POST) %{host}")
  response = doHttpPost(host,post_data)
  token = response['private_token']
  proj_name=SecureRandom.hex

  Gitlab.configure do |config|
    config.endpoint       = 'http://localhost:10080/api/v3'
    config.private_token  = token
  end

  begin
    group=create_group(proj_name,{})
    project=create_project(proj_name,{})

    node["pipeline"]["user"].each do |user|
      Chef::Log.debug("Creating #{user[:name]} for #{proj_name}")

      email="#{proj_name}@x.org".to_s
      userObj=create_user(email, 'password', SecureRandom.hex, { name: "#{SecureRandom.hex} Demo User" })
      add_user_to_group(userObj,group)
      add_user_ssh_key(user)
      assign_project_to_group(project,group)
    end
  rescue
    Chef::Log.error("Cannot Complete Gitlab Init #{$!}")
  end

end

def create_group(proj_name,options = {})
  group =  Gitlab.client.create_group(proj_name,proj_name,options)
  PP.pp(group)
#  Chef::Log.debug("Group #{PP.pp(group)}")
  return group
end

def create_project(proj_name,options={})
  proj =  Gitlab.client.create_project(proj_name,options)
  PP.pp(proj)
  return proj

end

def create_user(email,password,username,jsonAttrs)
  user = Gitlab.client.create_user(email, password, "Username: #{username}" , jsonAttrs)
  PP.pp(user)
  return user
end

def add_user_to_group(user,group)
  Gitlab.client.add_group_member(group.id, user.id, 40)
end

def assign_project_to_group(project,group)
  Gitlab.client.transfer_project_to_group(group.id,project.id)
end

def add_user_ssh_key(user)
  key = Gitlab.client.create_ssh_key("#{user.name}","#{user.sshkey}")
  PP.pp(key)
end


def doHttpPost(_host,_post_data)
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
