requires 'Email::Valid::Loose', '0.05';
requires 'FormValidator::Lite', '0.24';
requires 'List::MoreUtils', '0.22';
requires 'Mouse', '0.9';
requires 'parent';
requires 'perl', '5.008001';

on build => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
};
