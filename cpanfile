requires 'Email::Valid::Loose', '0.05';
requires 'FormValidator::Lite', '0.24';
requires 'Hash::MultiValue';
requires 'HTML::Escape';
requires 'List::MoreUtils', '0.22';
requires 'List::Util', '1.32';
requires 'Mouse', '0.9';
requires 'parent';
requires 'perl', '5.008001';

recommends 'DateTime';
recommends 'DateTime::Format::HTTP';
recommends 'HTML::Scrubber';
recommends 'Lingua::JA::Regular::Unicode';
recommends 'Mouse::Role';
recommends 'Scalar::Util';

on test => sub {
    requires 'CGI';
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
    recommends 'DBIx::Skinny';
    recommends 'DBIx::Skinny::Row';
    recommends 'DBIx::Skinny::Schema';
    recommends 'HTTP::Request::Common';
    recommends 'Plack::Request';
    recommends 'Plack::Test';
};

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on develop => sub {
    requires 'Perl::Critic', '1.105';
    requires 'Test::Perl::Critic', '1.02';
    suggests 'HTML::FormFu';
};
