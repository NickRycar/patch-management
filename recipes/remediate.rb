#
# Cookbook Name:: patch-management
# Recipe:: default
#
# Copyright 2014, Chef Software, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Load our package comparison helper
::Chef::Resource::Package.send(:include, PatchManagement::Helper)

if node['patch-management']['packages'].is_a?(Hash)
  node['patch-management']['packages'].each do |pkg, vrs|
    if node['software'][pkg]
        package "#{pkg}" do
          action :upgrade
          not_if { pkg_newer?( node['software'][pkg]['version'], "#{vrs}" ) }
          notifies :run, "ruby_block[patched_successfully]"
        end
    else
      package "#{pkg}" do
        action :install
        notifies :run, "ruby_block[patched_successfully]"
      end
    end
  end
else
  Chef::Log.fatal('`node["patch-management"]["packages"]` must be a Hash.')
end

#node.override['patch-management']['patched'] = true
#tag_me!('patched-successfully')

#tag during execution instead of compile time
ruby_block "patched_successfully" do
  block do
    node.normal[:tags].push('patched-successfully') unless node.normal[:tags].include?('patched-successfully')
  end
  action :nothing
end