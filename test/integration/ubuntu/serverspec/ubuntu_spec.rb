require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'patch-management::default' do

  describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('apache2'), :if => os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('openssl') do
    it { should be_installed }
  end

  describe package('bash') do
    it { should be_installed }
  end

  describe command('dpkg --compare-versions `dpkg -s apache2 | grep Version: | cut -f2 -d \' \'` ge 2.2.22-1ubuntu1.7'), :if => os[:family] == 'ubuntu' do
    its(:exit_status) { should eq 0 }
  end

  describe command('dpkg --compare-versions `dpkg -s bash | grep Version: | cut -f2 -d \' \'` ge 4.2-2ubuntu2.6'), :if => os[:family] == 'ubuntu' do
    its(:exit_status) { should eq 0 }
  end

  describe command('dpkg --compare-versions `dpkg -s openssl | grep Version: | cut -f2 -d \' \'` ge 1.0.1-4ubuntu5.12'), :if => os[:family] == 'ubuntu' do
    its(:exit_status) { should eq 0 }
  end

end