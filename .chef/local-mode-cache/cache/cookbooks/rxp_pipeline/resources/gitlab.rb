property :host, String
property :post_data,  :kind_of => Hash


action :setup do
  Chef::Log.debug("Calling (POST) %{host}")
  response = doPost(host,post_data)
  token = response['private_token']
#  add_group(token)
  add_members(token)
#  add_project(token)
#  assign_group(token)
end

def add_members(token)
  ["demo-user"].each do |user|
    Chef::Log.debug("Adding User=  #{user}")
    group_create_url = "#{node.default['pipeline']['gitlab_url']}/users"
    post_data_g = {:name=>'apm-chef-user',
                   :username=>"apm-chef-user",
                   :email=>"#{user}@pipeline.com",
                   :password=>"password",
                   :private_token=>token}
    host_g = group_create_url
    Chef::Log.debug("Token =  #{token}")
    response = doPost(host_g,post_data_g)
    Chef::Log.debug("response =  #{response}")
  end
end

def  add_project(token) 
end
def assign_group(token) 
end
def add_group(token)
  group_create_url = "#{node.default['pipeline']['gitlab_url']}/groups"
  post_data_g = {:name=>'apm-chef',:path=>"apm-chef",:private_token=>token}
  host_g = group_create_url
  Chef::Log.debug("Token =  #{token}")
  response = doPost(host_g,post_data_g)
  Chef::Log.debug("response =  #{response}")
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
