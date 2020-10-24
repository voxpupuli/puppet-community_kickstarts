# Define: community_kickstarts::centos7
# =====================================
#
# A skeleton for a minimal but useful Centos7 build. Can be further customized via parameter override.
#
# Assumptions:
#  * The OS will install from CentOS mirrors on the internet. Modify $url to change this.
#  * The completed VM will use DHCP and has the hostname 'kickstarted.example.com'. Modify $network to change this.
#  * SELinux is set to Enforcing mode. Modify $selinux to change this (but really, don't change it!)
#  * The timezone is UTC. Modify $timezone to change this.
#  * You want the latest version of puppet from the Puppet Collection 1. Modify $puppet_repo to change the repo
#    or provide an alternative template to $post_fragments to install a specific version.
#  * 100GB or larger hard drive - modify the partition configuration for smaller drives
#    or to make sure of space after the first 100GB
#    (A small amount is unpartitioned, to avoid rounding errors depending on the storage provider)
#  * Target is a VM and does not require the default firmware packages.
#
# Parameters
# ----------
#
# * `rootpw`
#   The root user's password. Use --plaintext or --encrypted before the string.
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
  $puppet_repo             = 'https://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-1.0.0-1.el7.noarch.rpm',
  $fragment_variables      = {},
  $repos                   = {},
  $partition_configuration = {
    zerombr   => '',
    clearpart => '--all --drives=sda --initlabel',
    part      => [
      '/boot --fstype=ext4 --size=500',
      'pv.2 --grow --size=200',
    ],
    volgroup  => 'VolGroup00 --pesize=4096 pv.2',
    logvol    => [
      '/home --fstype=ext4 --name=lv_home --vgname=VolGroup00 --size=80000',
      '/ --fstype=ext4 --name=lv_root --vgname=VolGroup00 --size=12000',
      'swap --name=lv_swap --vgname=VolGroup00 --size=4096',
    ],
  },
  $additional_packages     = [],
  $additional_commands     = {},
  $required_packages       = [
    '@core',
    'ntpdate',
    'ntp',
    'wget',
    'screen',
    'git',
    'openssh-clients',
    'open-vm-tools',
    'man',
    'mlocate',
    'bind-utils',
    'traceroute',
    'mailx',
    '-iwl5000-firmware',
    '-ivtv-firmware',
    '-xorg-x11-drv-ati-firmware',
    '-iwl4965-firmware',
    '-iwl3945-firmware',
    '-iwl5150-firmware',
    '-iwl6050-firmware',
    '-iwl6000g2a-firmware',
    '-iwl6000-firmware',
    '-iwl100-firmware',
    '-aic94xx-firmware',
    '-iwl1000-firmware',
    '-alsa-tools-firmware',
    '-iwl3160-firmware',
    '-iwl6000g2b-firmware',
    '-iwl2030-firmware',
    '-iwl2000-firmware',
    '-linux-firmware',
    '-alsa-firmware',
    '-iwl7265-firmware',
    '-iwl105-firmware',
    '-iwl135-firmware',
    '-iwl7260-firmware',
  ],
) {
  $base_repo = { base => { baseurl => $url } }

  $commands = {
    install    => true,
    url        => "--url ${url}",
    lang       => $lang,
    keyboard   => $keyboard,
    cmdline    => true,
    network    => $network,
    rootpw     => $rootpw,
    firewall   => $firewall,
    authconfig => $authconfig,
    selinux    => $selinux,
    timezone   => $timezone,
    bootloader => $bootloader,
    reboot     => true,
  }

  $fragments = {
    "post --log ${post_log}" => $post_fragments,
  }
  $puppet_fragment_variables = {
    'puppet_repo' => $puppet_repo,
  }

  ::kickstart { $name:
    packages                => unique(concat($additional_packages, $required_packages)),
    commands                => merge($commands, $additional_commands),
    partition_configuration => $partition_configuration,
    repos                   => merge($base_repo, $repos),
    fragments               => $fragments,
    fragment_variables      => merge($puppet_fragment_variables,$fragment_variables),
  }
}
