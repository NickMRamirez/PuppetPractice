# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  puppet_install_cmd = %Q(
	# CentOS 7 Puppet Enterprise installer
	# https://puppetlabs.com/download-puppet-enterprise-get-expand
	PUPPET_DOWNLOAD_URL=https://pm.puppetlabs.com/puppet-enterprise/2015.3.1/puppet-enterprise-2015.3.1-el-7-x86_64.tar.gz
	PUPPET_INSTALLER=puppet-enterprise-2015.3.1-el-7-x86_64.tar.gz
	PUPPET_INSTALL_DIR=/home/vagrant/puppet-enterprise-2015.3.1-el-7-x86_64
  
	echo "Checking if Puppet Enterprise is installed..."
	
	if [ ! -d $PUPPET_INSTALL_DIR ]; then
	  echo "Download Puppet Enterprise"
	  cd /home/vagrant
	  wget $PUPPET_DOWNLOAD_URL
	
	  echo "Installing Puppet Enterprise..."
	  # cp /vagrant/$PUPPET_INSTALLER /home/vagrant
	  tar xvzf /home/vagrant/$PUPPET_INSTALLER
	  rm /home/vagrant/$PUPPET_INSTALLER
	  PATH_TO_ANSWERS_FILE=/vagrant/puppetmaster.answers
	  $PUPPET_INSTALL_DIR/puppet-enterprise-installer -a $PATH_TO_ANSWERS_FILE -V 
	else
	  echo "Puppet Enterprise is already installed."
	fi
  )
  
  puppet_code_dir_cmd = %Q(
    if [[ -L "/etc/puppetlabs/code" && -d "/etc/puppetlabs/code" ]]; then
      echo "Code directory is already symlinked."
	else
	  echo "Replace default code directory with link to our own code directory..."
	  cd /etc/puppetlabs
	  sudo rm -rf code
	  sudo ln -s /vagrant/code
	  sudo ls /etc/puppetlabs/code
	fi
  )
  
  puppet_generate_cert_cmd = %Q(
    echo "Generating Puppet Master certificate..."
    puppet cert generate puppetmaster --dns_alt_names="puppet;10.10.0.2"
  )
  
  puppet_agent_install_cmd = %Q(
	$PUPPET_AGENT_DOWNLOAD_URL = "https://pm.puppetlabs.com/puppet-agent/2015.3.0/1.3.2/repos/windows/puppet-agent-1.3.2-x64.msi?_ga=1.250380614.1504919296.1450823152"
	$OUTPUT_DIR = "C:\\puppet-agent-1.3.2-x64.msi"
	
	if (Test-Path $OUTPUT_DIR)
	{
		Write-Host "Puppet already downloaded."
	}
	else
	{
	  Write-Host "Downloading Puppet Agent..."
	  Invoke-WebRequest $PUPPET_AGENT_DOWNLOAD_URL -OutFile $OUTPUT_DIR
	
	  msiexec /norestart /qn /i $OUTPUT_DIR PUPPET_MASTER_SERVER=10.10.0.2 PUPPET_AGENT_CERTNAME=node1
	}
	
	New-NetFirewallRule -DisplayName PuppetAgent -Direction Outbound -LocalPort 8140 -Protocol TCP -Action Allow
	
	# Send certificate request to puppet master
	Set-Location "C:\\Program Files\\Puppet Labs\\Puppet\\bin"
	puppet.bat agent --test
  )
  
  # Puppet master GUI: https://10.10.0.2
  # Puppetmaster GUI username: admin
  # Puppetmaster GUI password: P@ssw0rd
  # On command-line, you MUST run puppet commands as root. Enter `su -` to log on as root.

  config.vm.define 'puppetmaster' do |master|
    master.vm.box = 'bento/centos-7.1'
	master.vm.hostname = 'puppetmaster'
    master.vm.network 'private_network', ip: '10.10.0.2'
	master.vm.provision 'shell', inline: puppet_install_cmd
	master.vm.provision 'shell', inline: puppet_code_dir_cmd
	master.vm.provision 'shell', inline: puppet_generate_cert_cmd
	master.vm.boot_timeout = 1800
	
	master.vm.provider :virtualbox do |vb|
	  vb.customize ['modifyvm', :id, '--memory', '4096']
	end
  end
  
  config.vm.define 'node1' do |node|
    node.vm.box = 'kensykora/windows_2012_r2_standard'
	node.vm.hostname = 'node1'
	node.vm.network 'private_network', ip: '10.10.0.3'
	node.vm.boot_timeout = 1800
	
	node.vm.provision 'shell', inline: puppet_agent_install_cmd
  end

end
