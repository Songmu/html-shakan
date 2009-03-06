package t::004;
use Any::Moose;
use utf8;
use Test::More tests => 3;
use HTML::Shakan::Filters;

is(HTML::Shakan::Filters->filter('WhiteSpace', 'foo '), 'foo');

SKIP: {
    skip 'L::JA::Regular::Unicode is requird', 3 unless eval 'use Lingua::JA::Regular::Unicode; 1;';
    is(HTML::Shakan::Filters->filter('KatakanaZ', 'あこてぃえ'), 'アコティエ');
    is(HTML::Shakan::Filters->filter('Hiragana', 'アコティエ'), 'あこてぃえ');
};

