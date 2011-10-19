use strict;
use warnings FATAL => 'all';
use Module::Build;

my $build = Module::Build->new(
    license              => 'perl',
    recursive_test_files => 1,
    dynamic_config       => 0,
    build_requires       => {
        'Test::Requires' => '0.06',
        'Test::More'     => '0.96'
    },
    configure_requires => { 'Module::Build' => '0.38' },
    test_requires      => undef,
    requires           => {
        'perl'                => '5.008001',
        'parent'              => '0',
        'Mouse'               => '0.9',
        'Any::Moose'          => '0.13',
        'List::MoreUtils'     => '0.22',
        'FormValidator::Lite' => '0.24',
        'Email::Valid::Loose' => '0.05'
    },
    no_index    => { 'directory' => [ 't', 'inc' ] },
    name        => 'HTML-Shakan',
    module_name => 'HTML::Shakan',

    test_files => ( -d '.git' || $ENV{RELEASE_TESTING} ) ? 't/ xt/' : 't/',

    create_readme  => 1,
    create_license => 1,
);
$build->create_build_script();
