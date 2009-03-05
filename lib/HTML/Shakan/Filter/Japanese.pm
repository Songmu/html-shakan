package HTML::Shakan::Filter::Japanese;
use strict;
use warnings;
use Lingua::JA::Regular::Unicode qw(
    hiragana2katakana
    katakana2hiragana
    katakana_z2h
    katakana_h2z
);

sub filters {
    +{
        'KatakanaZ' => sub {
            $_ = hiragana2katakana(katakana_h2z($_))
        },
        'KatakanaH' => sub {
            $_ = katakana_z2h(hiragana2katakana($_))
        },
        'Hiragana' => sub {
            $_ = katakana2hiragana($_)
        },
    };
}

1;
