use inc::Module::Install;

name     'MojoX-Session-Store-Redis';
all_from 'lib/MojoX/Session/Store/Redis.pm';
author   q{BlueT - Matthew Lien - 練喆明 <BlueT@BlueT.org>};
license  'perl';

requires 'Redis'		=> 0;
requires 'namespace::clean'	=> 0;
requires 'MojoX::Session::Store'	=> 0;

build_requires 'Test::More';

auto_install;

WriteAll;

