use inc::Module::Install;
name 'HTML-Shakan';
all_from 'lib/HTML/Shakan.pm';

requires 'FormValidator::Lite' => 0.24;
requires 'Any::Moose'          => 0.13;
requires 'Mouse'               => 0.90;
requires 'List::MoreUtils'     => 0.22;
requires 'Email::Valid::Loose' => 0.05;
requires 'parent';

recommends 'Lingua::JA::Regular::Unicode';

test_requires 'Test::Requires' => 0.06;
test_requires 'Test::More' => 0.96;

tests 't/*.t t/*/*.t';
author_tests 'xt';

WriteAll;
