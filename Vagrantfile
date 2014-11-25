# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  $domain = 'localdomain'
  $trusty64_box = 'ubuntu/trusty64'
  $trusty64_url = 'https://vagrantcloud.com/ubuntu/boxes/trusty64'

  $nodes = {
    teamcity: { :hostname => 'teamcity', :ip => '192.168.80.10', :ram => '2048' },
    agent0: { :hostname => 'agent0',  :ip => '192.168.80.12', :ram => '2048', :box => $trusty64_box, :url => $trusty64_url }
  }

  def with_node_configuration(node_config, node)
      node_config.vm.box = node[:box] ? node[:box] : $trusty64_box
      node_config.vm.box_url = node[:url] ? node[:url] : $trusty64_url

      node_config.vm.hostname = node[:hostname] + '.' + $domain
      node_config.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 256

      node_config.vm.provider :virtualbox do | vbox |
        vbox.gui = false
        vbox.customize ['modifyvm', :id, '--name', node[:hostname]]
        vbox.customize ['modifyvm', :id, '--memory', memory.to_s]
      end
  end

  config.vm.define $nodes[:teamcity][:hostname] do | node_config |
    with_node_configuration node_config, $nodes[:teamcity]
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/teamcity_install.sh'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/teamcity_nginx.sh'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/teamcity_start.sh'
    end
  end

  config.vm.define $nodes[:agent0][:hostname] do | node_config |
    with_node_configuration node_config, $nodes[:agent0]

    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_teamcity_agent.sh'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/node.sh'
    end
  end
end
