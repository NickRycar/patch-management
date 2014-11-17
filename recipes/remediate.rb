

if node['patch-management']['packages'].is_a?(Hash)
	node['patch-management']['packages'].each do |pkg, vrs|
		if vrs == "latest"
			package pkg.to_s do
				action :upgrade
			end
		else
			package pkg.to_s do
				version vrs.to_s
				action :install
			end
		end
	end
else
	Chef::Log.warn('`node["patch-management"]["packages"]` must be a Hash.')
end

