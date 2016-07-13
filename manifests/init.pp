class tresorit (
  $user,
){
  file { '/opt/tresorit':
    ensure => directory,
  }
  remote_file { '/opt/tresorit/tresorit_installer.run':
    ensure => present,
    source => 'https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run',
    owner  => $user,
    mode   => '0755',
  }
  file { '/opt/tresorit/tresorit.sh':
    ensure  => present,
    mode    => '0755',
    owner   => $user,
    content => "#!/bin/bash
/opt/tresorit/tresorit_installer.run << EOF
n
n
EOF",
  }
  exec { 'install_tresorit':
    command     => '/opt/tresorit/tresorit.sh',
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    user        => $user,
    creates     => "/home/${user}/.local/share/tresorit",
    environment => ["HOME=/home/${user}"],
    require     => Remote_file['/opt/tresorit/tresorit_installer.run'],
  }
}
