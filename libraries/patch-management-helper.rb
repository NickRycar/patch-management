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

		def pkg_newer?(a,b)
			case node['platform_family']
			when 'debian'
				dpkg_newer?(a,b)
			when 'rhel'
				rpm_newer?(a,b)
			end
		end

		def rpm_installed?(pkg)
			cmd = shell_out("rpm -q #{pkg}")
			case cmd.exitstatus
			when 0
				return true
			when 1
				return false
			end
		end

		def dpkg_installed?(pkg)
			cmd = shell_out("dpkg -s #{pkg}")
			case cmd.exitstatus
			when 0
				return true
			when 1
				return false
			end
		end

		def pkg_installed?(pkg)
			case node['platform_family']
			when 'rhel'
				rpm_installed?(pkg)
			when 'debian'
				dpkg_installed?(pkg)
			end
		end

		def rpm_version(pkg)
			cmd = shell_out("rpm -q #{pkg} | cut -d \'-\' -f 2-")
			return cmd.stdout.strip
		end

		def dpkg_version(pkg)
			cmd = shell_out("dpkg -s #{pkg} | grep Version: | cut -f2 -d \' \'")
			return cmd.stdout.strip
		end

		def pkg_version(pkg)
			case node['platform_family']
			when 'rhel'
				rpm_version(pkg)
			when 'debian'
				dpkg_version(pkg)
			end
		end

	end
end