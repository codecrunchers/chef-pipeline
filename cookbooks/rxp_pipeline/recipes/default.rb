#
# Cookbook Name:: rxp-pipeline
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

chef_gem 'gitlab'

include_recipe 'rxp_pipeline::docker'
include_recipe 'rxp_pipeline::gitlab_config'







