
use Test::More;
use HTML::Shakan;
use t::Util;

use Test::Requires 'DateTime', 'DateTime::Format::HTTP';
plan tests => 5;
require HTML::Shakan::Inflator::DateTime;

my $form = HTML::Shakan->new(
    request => query({
        birthdate_year => 2009,
        birthdate_month=> 9,
        birthdate_day => 2,
    }),
    fields => [
        DateField(
            name => 'birthdate',
            inflator => HTML::Shakan::Inflator::DateTime->new(
            ),
        )
    ],
);
is $form->has_error, 0;
isa_ok $form->param('birthdate'), 'DateTime';
is $form->param('birthdate')->year, 2009;
is $form->param('birthdate')->month, 9;
is $form->param('birthdate')->day, 2;

