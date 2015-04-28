# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  $domain = 'local'
  $trusty64_box = 'ubuntu/trusty64'
  $trusty64_url = 'https://vagrantcloud.com/ubuntu/boxes/trusty64'
  $win81_box = 'fundpuls/windows-81'
  $win81_url = 'https://atlas.hashicorp.com/fundpuls/boxes/windows-81'
  $osx_box = 'AndrewDryga/vagrant-box-osx'
  $osx_url = 'http://files.dryga.com/boxes/osx-yosemite-0.2.0.box'

  $nodes = {
    teamcity: { :hostname => 'teamcity', :ip => '192.168.50.170', :ram => '2048' },
    agentOSX: { :hostname => 'agentOSX',  :ip => '192.168.50.171', :ram => '2048', :box => $osx_box, :url => $osx_url },
    agentWin: { :hostname => 'agentWin',  :ip => '192.168.50.172', :ram => '2048', :box => $win81_box, :url => $win81_url }
    #agentUbuntu: { :hostname => 'agentUbuntu',  :ip => '192.168.50.173', :ram => '2048', :box => $trusty64_box, :url => $trusty64_url }
  }

  def with_node_configuration(node_config, node, nfs_synced_folder=false)
      node_config.vm.box = node[:box] ? node[:box] : $trusty64_box
      node_config.vm.box_url = node[:url] ? node[:url] : $trusty64_url

      node_config.vm.hostname = node[:hostname] #+ '.' + $domain
      node_config.vm.network :private_network, ip: node[:ip]

      if nfs_synced_folder
        node_config.vm.synced_folder ".", "/vagrant", type: "nfs"
      end

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
      shell.path = 'vagrant/teamcity_postgresql.sh'
    end
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

  config.vm.define $nodes[:agentOSX][:hostname] do | node_config |
    with_node_configuration node_config, $nodes[:agentOSX], true

    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_osx_teamcity_agent.sh'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_osx_cmake.sh'
    end
  end

  config.vm.define $nodes[:agentWin][:hostname] do | node_config |
    with_node_configuration node_config, $nodes[:agentWin], true
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_win_chocolatey.cmd'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_win_teamcity_agent.cmd'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_win_cmake.cmd'
    end
    node_config.vm.provision :shell do | shell |
      shell.path = 'vagrant/setup_win_visualstudio2013express_desktop.cmd'
    end
  end
#  config.vm.define $nodes[:agentUbuntu][:hostname] do | node_config |
#    with_node_configuration node_config, $nodes[:agentUbuntu]
#
#    node_config.vm.provision :shell do | shell |
#      shell.path = 'vagrant/setup_ubuntu_agent.sh'
#    end
#  end
end
