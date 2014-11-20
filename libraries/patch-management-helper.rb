module PatchManagement
  module Helper
    include Chef::Mixin::ShellOut

    def pkg_newer?(a,b)
      case node['platform_family']
      when 'debian'
        dpkg_newer?(a,b)
      when 'rhel'
        rpm_newer?(a,b)
      end
    end

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
      # magic spagetti
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

    # def tag_me!(status)
    #   case status
    #   when AUDIT_FAILED
    #     if tagged?(AUDIT_FAILED) && !tagged?(AUDIT_PASSED)
    #       Chef::Log.info('This machine failed the audit, but was already tagged as such.')
    #     elsif !tagged?(AUDIT_FAILED) && tagged?(AUDIT_PASSED)
    #       untag(AUDIT_PASSED)
    #       tag(AUDIT_FAILED)
    #     elsif !tagged?(AUDIT_FAILED) && !tagged?(AUDIT_PASSED)
    #       tag(AUDIT_FAILED)
    #     end
    #     untag(AUDIT_STARTED) if tagged?(AUDIT_STARTED)
    #   when AUDIT_PASSED
    #     if tagged?(AUDIT_PASSED) && !tagged?(AUDIT_FAILED)
    #       Chef::Log.info('This machine passed the audit, but was already tagged as such.')
    #     elsif !tagged?(AUDIT_PASSED) && tagged?(AUDIT_FAILED)
    #       untag(AUDIT_FAILED)
    #       tag(AUDIT_PASSED)
    #     elsif !tagged?(AUDIT_FAILED) && !tagged?(AUDIT_PASSED)
    #       tag(AUDIT_PASSED)
    #     end
    #     untag(AUDIT_STARTED) if tagged?(AUDIT_STARTED)
    #   when PATCHED
    #     if tagged?(PATCHED)
    #       Chef::Log.info('This machine was patched successfully, but was already tagged as such.')
    #     elsif !tagged?(PATCHED)
    #       tag(PATCHED)
    #     end
    #     untag(AUDIT_STARTED) if tagged?(AUDIT_STARTED)
    #   end
    # end
  end
end