#
# Cookbook Name:: rxp-pipeline
# Recipe:: create_project
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
#   TODO: Fix ssh
#    echo -e "Host github.io\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
#
extract_path='/tmp/proj'
project_name=sanitize_filename(node['pipeline']['project_name'])
remote="ssh://git@localhost:10022/#{project_name}/#{project_name}.git"
bash 'create app' do
  code <<-EOH
    mkdir -p #{extract_path}
    cd #{extract_path}

    JAVA_HOME="#{node['pipeline']['java_home']}" #{node['pipeline']['maven_path']} archetype:generate -B \
      -DarchetypeGroupId=#{node['pipeline']['archetype']['groupId']} \
      -DarchetypeArtifactId=#{node['pipeline']['archetype']['archetypeId']} \
      -DarchetypeVersion=#{node['pipeline']['archetype']['archetypeVersion']} \
      -DgroupId=com.rxp \
      -DartifactId=#{project_name} \
      -Dversion=1.0 \
      -DarchetypeRepository=#{node['pipeline']['archetype']['archetypeRepo']}
      cd #{project_name}

      git init
      git add --all
      git commit -am "pipeline create"
      git remote add origin #{remote}
      git push --set-upstream origin master
    EOH
    not_if { ::File.exist?(extract_path) }
end


