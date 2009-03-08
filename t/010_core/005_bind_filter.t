use strict;
use warnings;
use Test::More tests => 2;
use HTML::Shakan;
use CGI;

my $form = HTML::Shakan->new(
    request => CGI->new({f => ' oo ', 'b' => 1}),
    fields => [
        TextField(
            name     => 'f',
            required => 1,
            filters  => ['WhiteSpace']
        )
    ],
);
is $form->is_valid(), 1;
is $form->param('f'), 'oo';

