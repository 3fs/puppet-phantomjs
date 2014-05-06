# Base class for phantomjs module
class phantomjs (
  $package_version = '1.9.2',
  $source_url = 'UNSET',
  $source_dir = '/opt',
  $install_dir = '/usr/local/bin',
  $package_update = false,

) {

  $pkg_src_url = $source_url ? {
    'UNSET' => "https://phantomjs.googlecode.com/files/phantomjs-${package_version}-linux-x86_64.tar.bz2",
    default => $source_url,
  }

  if ! defined(Package['curl']) {
    package { 'curl':
      ensure => present
    }
  }

  if ! defined(Package['bzip2']) {
    package { 'curl':
      ensure => present
    }
  }

  if ! defined(Package['libfontconfig1']) {
    package { 'libfontconfig1':
      ensure => present
    }
  }

  exec { 'get phantomjs':
    command => "/usr/bin/curl --silent --show-error ${pkg_src_url} --output ${source_dir}/phantomjs.tar.bz2 \
      && mkdir ${source_dir}/phantomjs && tar xjf ${source_dir}/phantomjs.tar.bz2 -C ${source_dir} \
      && mv ${source_dir}/phantomjs-${package_version}-linux-x86_64/* ${source_dir}/phantomjs/ \
      && rm -rf ${source_dir}/phantomjs-${package_version}-linux-x86_64",
    creates => "${source_dir}/phantomjs/",
    require => Package['curl', 'bzip2', 'libfontconfig1'],
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
