use strict;
use warnings;
use Test::More;
use HTML::Shakan;
use t::Util;
use Test::Requires 'Lingua::JA::Regular::Unicode';

subtest 'normal' => sub {
    my $form = HTML::Shakan->new(
        request => query({f => ' oo ', 'b' => 1}),
        fields => [
            TextField(
                name     => 'f',
                required => 1,
                filters  => ['WhiteSpace']
            ),
        ],
    );
    is $form->is_valid(), 1;
    is $form->param('f'), 'oo';
    done_testing;
};

subtest 'multiple filters' => sub {
    my $form = HTML::Shakan->new(
        request => query({f => ' アイウエオaiueo ', 'b' => 1}),
        fields => [
            TextField(
                name     => 'f',
                required => 1,
                filters  => [qw'WhiteSpace Hiragana']
            ),
        ],
    );
    is $form->is_valid(), 1;
    is $form->param('f'), 'アイウエオaiueo';
    done_testing;
};

done_testing;
