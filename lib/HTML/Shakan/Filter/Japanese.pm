package HTML::Shakan::Filter::Japanese;
use strict;
use warnings;
use Lingua::JA::Regular::Unicode qw(
    hiragana2katakana
    katakana_z2h
    katakana_h2z
);

sub init {
    +{
        'KatakanaZ' => sub {
            hiragana2katakana(katakana_h2z(shift))
        },
        'KatakanaH' => sub {
            katakana_z2h(hiragana2katakana(shift))
        },
    };
}

1;
