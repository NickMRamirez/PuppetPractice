node default {
}

node 'puppetmaster' {
  notice("Updating puppetmaster")
  
  file { '/home/vagrant/hello.txt' :
    ensure => present,
    content => 'Hello, puppet!'
  }
}

node 'node1' {
  class { 'profile::iis' :
  
  }
}