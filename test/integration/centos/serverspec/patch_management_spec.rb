require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'patch-management::default' do

  describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('openssl') do
    it { should be_installed }
  end

  describe package('bash') do
    it { should be_installed }
  end

  describe package('rpmdevtools') do
    it { should be_installed}
  end

  describe command('rpmdev-vercmp `rpm -q httpd | cut -d \'-\' -f 2-` 2.2.15-39.el6 |  grep `rpm -q httpd | cut -d \'-\' -f 2-`'), :if => os[:family] == 'redhat' do
    its(:exit_status) { should eq 0 }
  end

  describe command('rpmdev-vercmp `rpm -q bash | cut -d \'-\' -f 2-` 4.1.2-29.el6 |  grep `rpm -q bash | cut -d \'-\' -f 2-`'), :if => os[:family] == 'redhat' do
    its(:exit_status) { should eq 0 }
  end

  describe command('rpmdev-vercmp `rpm -q openssl | cut -d \'-\' -f 2-` 1.0.1e-16.el6_5.7 |  grep `rpm -q openssl | cut -d \'-\' -f 2-`'), :if => os[:family] == 'redhat' do
    its(:exit_status) { should eq 0 }
  end

end