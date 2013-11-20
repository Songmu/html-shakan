use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More;

diag "FVL: $FormValidator::Lite::VERSION";

sub check {
    my ($type, $fields, @plan) = @_;

    for my $args (@plan) {
        my $form = HTML::Shakan->new(
            request => $args->[0],
            fields => $fields,
        );
        is $form->is_valid, $args->[1], $type;
    }
}

check(
    'TextField(required)',
    [
        TextField(
            name     => 'name',
            required => 1,
        ),
    ],
    [ query(), 0 ],
    [ query( { name => 'oo' } ), 1 ]
);

check(
    'EmailField',
    [ EmailField( name => 'email' ) ],
    [ query( { email => 'oo' } ),             0 ],
    [ query( { email => 'oo@example.com' } ), 1 ]
);

check(
    'URLField',
    [ URLField( name => 'u' ) ],
    [ query( { u => 'm' } ), 0 ],
    [ query( { u => 'http://mixi.jp' } ), 1 ]
);

check(
    'UIntField',
    [ UIntField( name => 'u' ) ],
    [ query( { u => '-1' } ), 0 ],
    [ query( { u => 'abc' } ), 0 ],
    [ query( { u => '3' } ), 1 ]
);

check(
    'IntField',
    [ IntField( name => 'u' ) ],
    [ query( { u => '1.2' } ), 0 ],
    [ query( { u => '-1' } ), 1 ],
    [ query( { u => 'abc' } ), 0 ],
    [ query( { u => '3' } ), 1 ]
);

check(
    'ChoiceField',
    [ ChoiceField( name => 'u', choices => [a => 'b', c => 'd'] ) ],
    [ query( { u => 'a' } ), 1 ],
    [ query( { u => 'd' } ), 0 ],
    [ query( { u => 'ad' } ), 0 ],
);

check(
    'ChoiceField',
    [ ChoiceField( name => 'u', choices => [a => 'a', b => 'b'] ) ],
    [ query( { u => 'a' } ), 1 ],
    [ query( { u => [qw/a b/] } ), 1 ],
    [ query( { u => [qw/a c/] } ), 0 ],
);

check(
    'DateField',
    [ DateField( name => 'birthdate', years => [2000..2004], required => 1 ) ],
    [ query( { } ), 0 ],
    [ query( {
        'birthdate_year'    => 2004,
        'birthdate_month'   => 10,
        'birthdate_day'     => 3,
    } ), 1 ],
);

done_testing;
