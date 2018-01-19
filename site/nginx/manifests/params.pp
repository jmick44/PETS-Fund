class nginx::params {

 case $facts['os']['family'] {
    'redhat', 'debian': {
      $package  = 'nginx'
      $owner    = 'root'
      $group    = 'root'
      $docroot  = '/var/www'
      $confdir  = '/etc/nginx'
      $blockdir = '/etc/nginx/conf.d'
      $logdir  = '/var/log/nginx'
      $service  = 'nginx'
    }
    default : {
      fail("OS not supported")
    }
  }
  
  $user = $facts['os']['family'] ? {
    'redhat' => 'nginx',
    'debian' => 'www-data',
    default  => 'fail',
  }
  
  if $user == 'fail' {
    fail("OS not supported")
  }

}