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

if node['patch-management']['packages'].is_a?(Hash)
	node['patch-management']['packages'].each do |pkg, vrs|
		package "#{pkg}" do
			version "#{vrs}"
			action :install
		end
	end
else
	Chef::Log.warn('`node["patch-management"]["packages"]` must be a Hash.')
end

node.override['patch-management']['patched'] = true