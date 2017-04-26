requires 'Email::Valid::Loose', '0.05';
requires 'FormValidator::Lite', '0.24';
requires 'HTML::Escape';
requires 'Hash::MultiValue';
requires 'List::MoreUtils', '0.22';
requires 'List::Util', '1.32';
requires 'Mouse', '0.9';
requires 'MouseX::NativeTraits', '1.09';
requires 'Scalar::Util';
requires 'parent';
requires 'perl', '5.008001';

recommends 'DateTime';
recommends 'DateTime::Format::HTTP';
recommends 'HTML::Scrubber';
recommends 'Lingua::JA::Regular::Unicode';


on configure => sub {
    requires 'Module::Build';
};

on test => sub {
    requires 'CGI';
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
    recommends 'DBIx::Skinny';
    recommends 'DBIx::Skinny::Row';
    recommends 'DBIx::Skinny::Schema';
    recommends 'Teng';
    recommends 'Teng::Row';
    recommends 'Teng::Schema::Declare';
};

on develop => sub {
    requires 'DBD::SQLite', '1.31';
    requires 'DBIx::Skinny', '0.0740';
    requires 'Data::Model';
    requires 'DateTime';
    requires 'DateTime::Format::HTTP';
    requires 'HTTP::Request::Common';
    requires 'Lingua::JA::Regular::Unicode';
    requires 'Plack::Request';
    requires 'Plack::Test';
    requires 'Teng', '0.28';
    recommends 'Perl::Critic', '1.105';
    recommends 'Test::Perl::Critic', '1.02';
    suggests 'HTML::FormFu';
};
