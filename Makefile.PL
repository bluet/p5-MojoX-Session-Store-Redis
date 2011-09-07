use inc::Module::Install;

name     'MojoX-Session-Store-Redis';
all_from 'lib/MojoX/Session/Store/Redis.pm';
author   q{BlueT - Matthew Lien - 練喆明 <BlueT@BlueT.org>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

