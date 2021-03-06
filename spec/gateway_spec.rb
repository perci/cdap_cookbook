require 'spec_helper'

describe 'cdap::gateway' do
  context 'on Centos 6.5 x86_64' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.5) do |node|
        node.automatic['domain'] = 'example.com'
        node.default['hadoop']['hdfs_site']['dfs.datanode.max.transfer.threads'] = '4096'
        node.default['hadoop']['mapred_site']['mapreduce.framework.name'] = 'yarn'
        stub_command('update-alternatives --display cdap-conf | grep best | awk \'{print $5}\' | grep /etc/cdap/conf.chef').and_return(false)
        stub_command('update-alternatives --display hadoop-conf | grep best | awk \'{print $5}\' | grep /etc/hadoop/conf.chef').and_return(false)
        stub_command('update-alternatives --display hbase-conf | grep best | awk \'{print $5}\' | grep /etc/hbase/conf.chef').and_return(false)
        stub_command('update-alternatives --display hive-conf | grep best | awk \'{print $5}\' | grep /etc/hive/conf.chef').and_return(false)
        stub_command('test -L /var/log/hadoop-hdfs').and_return(false)
        stub_command('test -L /var/log/hbase').and_return(false)
        stub_command('test -L /var/log/hive').and_return(false)
      end.converge(described_recipe)
    end

    it 'installs cdap-gateway package' do
      expect(chef_run).to install_package('cdap-gateway')
    end

    it 'creates cdap-gateway service, but does not run it' do
      expect(chef_run).not_to start_service('cdap-gateway')
    end

    it 'creates cdap-router service, but does not run it' do
      expect(chef_run).not_to start_service('cdap-router')
    end
  end
end
