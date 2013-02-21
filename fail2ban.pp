# puppet-fail2ban - Puppet module (od_jain)
#
# A simple Puppet module (this is only the manifest file) to setup fail2ban
# on a Ubuntu box.
#
# Depends on module content:  jail.local.erb template file
#                             filter.d/ directory
#

class fail2ban($ensure='running',
               $dest_email='root@localhost'
) {

  case $operatingsystem {
    ubuntu, debian: {
      $supported      = true
      $package_name   = 'fail2ban'
      $service_name   = 'fail2ban'
      $jail           = '/etc/fail2ban/jail.local'
      $jail_template  = 'jail.local.erb'
      $filter_dir     = '/etc/fail2ban/filter.d'
    }
    default: {
      $supported      = false
      notify { "${module_name}_unsupported":
        message => "The ${module_name} module is not supported on ${::operatingsystem} for now"
      }
    }
  }

  if ($supported == true) {

    package {'fail2ban':
      ensure    => present,
      name      => $package_name,
    }

    service { 'fail2ban':
      name      => $service_name,
      ensure    => $ensure,
      subscribe => [ Package[$package_name],
                     File[$jail],
                     File[$filter_dir] ],
    }

    file { $jail:
      ensure    => file,
      owner     => 0,
      group     => 0,
      mode      => '0644',
      content   => template("${module_name}/${jail_template}"),
      require   => Package[$package_name],
    }

    file { $filter_dir:
      ensure    => directory,
      owner     => 0,
      group     => 0,
      mode      => '0644',
      source    => "puppet:///modules/${module_name}/filter.d",
      recurse   => true,
      require   => Package[$package_name],
    }
  }
}
