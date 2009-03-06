package t::004;
use Any::Moose;
use utf8;
use Test::More tests => 5;
use HTML::Shakan::Filters;

is(HTML::Shakan::Filters->filter('WhiteSpace', 'foo '), 'foo');

SKIP: {
    skip 'L::JA::Regular::Unicode is requird', 3 unless eval 'use Lingua::JA::Regular::Unicode; 1;';
    is(HTML::Shakan::Filters->filter('KatakanaZ', 'あこてぃえ'), 'アコティエ');
    is(HTML::Shakan::Filters->filter('Hiragana', 'アコティエ'), 'あこてぃえ');
};

SKIP: {
    skip 'HTML::Scrubber is requird', 2 unless eval 'use HTML::Scrubber; 1;';
    is(
        HTML::Shakan::Filters->filter(
            'HTMLScrubber',
            '<script>alert("hoge");</script><a href="">acotie</a>おうっふー'
        ),
        'acotieおうっふー'
    );
    is(
        HTML::Shakan::Filters->filter(
            HTML::Shakan::Filter::HTMLScrubber->new(
                scrubber => HTML::Scrubber->new( allow => ['p'] )
            ),
            '<script>alert("hoge");</script><p>acotie</p>おうっふー'
        ),
        '<p>acotie</p>おうっふー'
    );
};
