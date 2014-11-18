module PatchManagement
	module Helper
		include Chef::Mixin::ShellOut

		def dpkg_newer?(a,b)
			cmd = shell_out("dpkg --compare-versions #{a} ge #{b}")
			case cmd.exitstatus
			when 0
				return true
			when 1
				return false
			end
		end

		def rpm_newer?(a,b)
			cmd = Chef::Provider::Package::Yum::RPMUtils.rpmvercmp(a,b)
			case cmd
			when 1
				return true
			when 0
				return true
			when -1
				return false
			end
		end

	end
end