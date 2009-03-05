use inc::Module::Install;
name 'HTML-Shakan';
all_from 'lib/HTML/Shakan.pm';

requires 'FormValidator::Lite';

recommends 'Lingua::JA::Regular::Unicode';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
