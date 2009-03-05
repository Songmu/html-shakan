package t::004;
use Any::Moose;
use utf8;
use Test::More tests => 4;
use HTML::Shakan::Filters;

is(HTML::Shakan::Filters->filter('WhiteSpace', 'foo '), 'foo');

SKIP: {
    skip 'L::JA::Regular::Unicode is requird', 3 unless eval 'use Lingua::JA::Regular::Unicode; 1;';
    HTML::Shakan::Filters->install_filters('Japanese');
    is(HTML::Shakan::Filters->filter('KatakanaZ', 'あこてぃえ'), 'アコティエ');
    is(HTML::Shakan::Filters->filter('KatakanaH', 'あこてぃえ'), 'ｱｺﾃｨｴ');
    is(HTML::Shakan::Filters->filter('Hiragana', 'アコティエ'), 'あこてぃえ');
};

