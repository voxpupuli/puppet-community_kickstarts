# Define: community_kickstarts::centos7
# =====================================
#
# A skeleton for Centos7 using sane defaults. Can be further customized via APL.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
define community_kickstarts::centos7 (
  $rootpw                  = '--plaintext changeme',
  $url                     = 'http://mirror.centos.org/centos/7/os/x86_64',
  $architecture            = 'x86_64',
  $lang                    = 'en_US.UTF-8',
  $keyboard                = 'us',
  $network                 = '--onboot yes --device eth0 --bootproto dhcp --hostname kickstarted.example.com',
  $firewall                = '--service=ssh',
  $authconfig              = '--enableshadow --passalgo=sha512',
  $selinux                 = '--enforcing',
  $timezone                = '--utc Etc/UTC',
  $bootloader              = '--location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"',
  $post_log                = '/root/ks-post.log',
  $post_fragments          = ['community_kickstarts/install_puppet.erb'],
  $puppet_repo             = 'https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm',
  $repos                   = {},
  $partition_configuration = {},
  $additional_packages     = [],
  $additional_commands     = {},
  $required_packages       = [
    '@core',
    '@server-policy',
    'ntpdate',
    'ntp',
    'wget',
    'screen',
    'git',
    'openssh-clients',
    'man',
    'mlocate',
    'bind-utils',
    'traceroute',
    'mailx',
    '-iwl5000-firmware-8.83.5.1_1-1.el6_1.1.noarch',
    '-ivtv-firmware-20080701-20.2.noarch',
    '-xorg-x11-drv-ati-firmware-7.1.0-3.el6.noarch',
    '-atmel-firmware-1.3-7.el6.noarch',
    '-iwl4965-firmware-228.61.2.24-2.1.el6.noarch',
    '-iwl3945-firmware-15.32.2.9-4.el6.noarch',
    '-rt73usb-firmware-1.8-7.el6.noarch',
    '-iwl5150-firmware-8.24.2.2-1.el6.noarch',
    '-iwl6050-firmware-41.28.5.1-2.el6.noarch',
    '-iwl6000g2a-firmware-17.168.5.3-1.el6.noarch',
    '-iwl6000-firmware-9.221.4.1-1.el6.noarch',
    '-ql2400-firmware-7.00.01-1.el6.noarch',
    '-ql2100-firmware-1.19.38-3.1.el6.noarch',
    '-libertas-usb8388-firmware-5.110.22.p23-3.1.el6.noarch',
    '-ql2500-firmware-7.00.01-1.el6.noarch',
    '-zd1211-firmware-1.4-4.el6.noarch',
    '-rt61pci-firmware-1.2-7.el6.noarch',
    '-ql2200-firmware-2.02.08-3.1.el6.noarch',
    '-ipw2100-firmware-1.3-11.el6.noarch',
    '-ipw2200-firmware-3.1-4.el6.noarch',
    '-bfa-firmware-3.2.21.1-2.el6.noarch',
    '-iwl100-firmware-39.31.5.1-1.el6.noarch',
    '-aic94xx-firmware-30-2.el6.noarch',
    '-iwl1000-firmware-39.31.5.1-1.el6.noarch',
  ],
) {

  $autopart  = empty($partition_configuration)
  $base_repo = { base => { baseurl => $url } }

  $commands = {
    install    => true,
    url        => $url,
    lang       => $lang,
    keyboard   => $keyboard,
    cmdline    => true,
    network    => $network,
    rootpw     => $rootpw,
    firewall   => $firewall,
    authconfig => $authconfig,
    selinux    => $selinux,
    timezone   => $timezone,
    autopart   => $autopart,
    bootloader => $bootloader,
    reboot     => true,
  }

  $fragments = {
    "post --log ${post_log}" => $post_fragments,
  }

  ::kickstart { $name:
    packages                => unique(concat($additional_packages, $required_packages)),
    commands                => merge($commands, $additional_commands),
    partition_configuration => $partition_configuration,
    repos                   => merge($base_repo, $repos),
    fragments               => $fragments,
  }
}
