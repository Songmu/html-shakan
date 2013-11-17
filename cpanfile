requires 'Email::Valid::Loose', '0.05';
requires 'FormValidator::Lite', '0.24';
requires 'HTML::Escape';
requires 'List::MoreUtils', '0.22';
requires 'Mouse', '0.9';
requires 'parent';
requires 'perl', '5.008001';

recommends 'CGI';
recommends 'DateTime';
recommends 'DateTime::Format::HTTP';
recommends 'HTML::Scrubber';
recommends 'Lingua::JA::Regular::Unicode';
recommends 'Mouse::Role';
recommends 'Scalar::Util';

on test => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
    recommends 'DBIx::Skinny';
    recommends 'DBIx::Skinny::Row';
    recommends 'DBIx::Skinny::Schema';
    recommends 'HTTP::Request::Common';
    recommends 'Plack::Request';
    recommends 'Plack::Test';
};

on develop => sub {
    # recommends 'HTML::FormFu';
};
