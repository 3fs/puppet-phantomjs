puppet-phantomjs
===============

Simple puppet module that installs PhantomJS - headless WebKit scriptable with a Javascript API.

Using
-----

	class { 'phantomjs': 
		package_version => '1.0.3',
		package_update => true,
		install_dir => '/usr/local/bin',
		source_dir => '/opt',
	}

Simple puppet module that installs PhantomJS
