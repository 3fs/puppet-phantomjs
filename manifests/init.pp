# Base class for phantomjs module
class phantomjs (
  $package_version = '1.9.7',
  $source_url = undef,
  $source_dir = '/opt',
  $install_dir = '/usr/local/bin',
  $package_update = false,

) {

  # Base requirements
  if $::kernel != 'Linux' {
    fail('This module is supported only on Linux.')
  }

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present
    }
  }

  if ! defined(Package['bzip2']) {
    package { 'bzip2':
      ensure => present
    }
  }

  # Ensure packages based on operating system exist
  case $::operatingsystem {
    /(?:CentOS|RedHat|Scientific)/: {
      # Requirements for CentOS/RHEL according to phantomjs.org
      if ! defined(Package['fontconfig']) {
        package { 'fontconfig':
          ensure => present
        }
      }

      if ! defined(Package['freetype']) {
        package { 'freetype':
          ensure => present
        }
      }

      if ! defined(Package['libstdc++']) {
        package { 'libstdc++':
          ensure => present
        }
      }

      if ! defined(Package['urw-fonts']) {
        package { 'urw-fonts':
          ensure => present
        }
      }

      $packages = [
        Package['curl'],
        Package['bzip2'],
        Package['fontconfig'],
        Package['freetype'],
        Package['libstdc++'],
        Package['urw-fonts']
      ]
    }
    default: {
      if ! defined(Package['libfontconfig1']) {
        package { 'libfontconfig1':
          ensure => present
        }
      }

      $packages = [
        Package['curl'],
        Package['bzip2'],
        Package['libfontconfig1']
      ]
    }
  }

  $pkg_src_url = $source_url ? {
    undef   => "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${package_version}-linux-${hardwaremodel}.tar.bz2",
    default => $source_url,
  }

  exec { 'get phantomjs':
    command => "/usr/bin/curl --silent --show-error --location ${pkg_src_url} --output ${source_dir}/phantomjs.tar.bz2 \
      && mkdir ${source_dir}/phantomjs \
      && tar --extract --file=${source_dir}/phantomjs.tar.bz2 --strip-components=1 --directory=${source_dir}/phantomjs",
    creates => "${source_dir}/phantomjs/",
    require => $packages
  }

  file { "${install_dir}/phantomjs":
    ensure => link,
    target => "${source_dir}/phantomjs/bin/phantomjs",
    force  => true,
  }

  if $package_update {
    exec { 'remove phantomjs':
      command => "/bin/rm -rf ${source_dir}/phantomjs",
      notify  => Exec[ 'get phantomjs' ]
    }
  }
}
