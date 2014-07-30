class fail2ban (
  $email = 'root@localhost',
  $ignoreip = ['127.0.0.1/8']
) {
  # varibles configured with hiera

  package {
    'fail2ban': ensure => present;
  }

  service { 'fail2ban':
    ensure     => running,
    enable     => true,
    hasrestart => true, 
    hasstatus  => true,
    require    => [
      Package ['fail2ban']
    ]
  }

  file { 
    "/etc/fail2ban/jail.d/22_${::lsbdistcodename}.conf":
      source => [
        "puppet:///modules/fail2ban/etc/fail2ban/jail.d/${::lsbdistcodename}.conf",
        "puppet:///modules/fail2ban/etc/fail2ban/jail.d/common.conf"
      ],
      notify  => Service['fail2ban'],
      require => Package['fail2ban'];

    '/etc/fail2ban/jail.d/00_local.conf':
      content => template("fail2ban/etc/fail2ban/jail.d/00_local.conf.erb"),
      notify  => Service['fail2ban'],
      require => Package['fail2ban'];
  }
}
