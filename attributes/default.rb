default['patch-management']['packages'] = {}
default['patch-management']['patched'] = false

# Helper Attribute for auditing
default['patch-management']['audit-status'] = ''

# Load custom ohai plugin	
default['ohai']['plugins']['patch-management'] = 'plugins'