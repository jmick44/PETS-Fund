class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
  $message  = "Jaime's default message",
) inherits nginx::params {

  File {
    owner   => $owner,
    group   => $group,
    mode    => '0644',
  }
  
  notify { "MESSAGE IS ------ $message": }

  file { $docroot:
    ensure => directory,
    mode   => '0755',
    before => File["${docroot}/index.html"],
  }
  
  file { "${docroot}/index.html":
    ensure  => file,
    content => epp('nginx/index.html.epp'),
    #source  => 'puppet:///modules/nginx/index.html',
    #require => File['/var/www'],
  }
  
  package { $package:
    ensure => present,
    before => File["${confdir}/nginx.conf", "${blockdir}/default.conf"],
  }
  
  file { "${confdir}/nginx.conf":
    ensure  => file,
    content => epp('nginx/nginx.conf.epp',
                    {
                      user => $user,
                      confdir => $confdir,
                      logdir => $logdir,
                      blockdir => $blockdir,
                    }),
    #source  => 'puppet:///modules/nginx/nginx.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }
  
  file { "${blockdir}/default.conf":
    ensure  => file,
    content => epp('nginx/default.conf.epp', {docroot => $docroot}),
    #source  => 'puppet:///modules/nginx/default.conf',
    #require => Package['nginx'],
    #notify  => Service['nginx'],
  }
  
  service { $service:
    ensure => running,
    enable => true,
    subscribe => File["${confdir}/nginx.conf", "${blockdir}/default.conf"],
  }
}