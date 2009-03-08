use inc::Module::Install;
name 'HTML-Shakan';
all_from 'lib/HTML/Shakan.pm';

requires 'FormValidator::Lite' => 0.02;
requires 'Any::Moose'          => 0.05;
requires 'Mouse'               => 0.19;
requires 'List::MoreUtils'     => 0.22;

recommends 'Lingua::JA::Regular::Unicode';

tests 't/*.t t/*/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
