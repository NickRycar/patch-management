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

# Load ohai custom plugins
include_recipe "ohai::default"

# Load our package comparison helper
::Chef::Recipe.send(:include, PatchManagement::Helper)

node.run_state['audit'] = 'patch-audit-passed'

if node['patch-management']['packages'].is_a?(Hash)
  node['patch-management']['packages'].each do |pkg,vrs|
    if node['software'][pkg]
        if pkg_newer?(node['software'][pkg]['version'], "#{vrs}")
          log "Package '#{pkg}' is installed and at version #{vrs} or later (Installed: #{node['software'][pkg]['version']})." do
            level :info
            notifies :run, "ruby_block[audit_status]", :immediately
          end
        else
          log "Package '#{pkg}' is installed, but needs to be patched!" do
            level :warn
            notifies :run, "ruby_block[audit_status]"
          end
          node.run_state['audit'] = 'patch-audit-failed'
        end
    else
      log "Package '#{pkg}' is not installed!" do
        level :warn
        notifies :run, "ruby_block[audit_status]"
      end
      node.run_state['audit'] = 'patch-audit-failed'
    end
  end
else
  Chef::Log.fatal('`node["patch-management"]["packages"]` must be a Hash.')
end


ruby_block "audit_status" do
  block do
    status = node.run_state['audit']
    case status
    when 'patch-audit-failed'
      node.normal[:tags].push(status) unless node.normal[:tags].include?(status)
      node.normal[:tags].delete('patch-audit-passed') if node.normal[:tags].include?('patch-audit-passed')
    when 'patch-audit-passed'
      node.normal[:tags].push(status) unless node.normal[:tags].include?(status)
      node.normal[:tags].delete('patch-audit-failed') if node.normal[:tags].include?('patch-audit-failed')
    end
  end
  action :nothing
end