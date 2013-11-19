use strict;
use warnings;
use HTML::Shakan;
use Test::More;
use CGI;

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
    [ CGI->new(), 0 ],
    [ CGI->new( { name => 'oo' } ), 1 ]
);

check(
    'EmailField',
    [ EmailField( name => 'email' ) ],
    [ CGI->new( { email => 'oo' } ),             0 ],
    [ CGI->new( { email => 'oo@example.com' } ), 1 ]
);

check(
    'URLField',
    [ URLField( name => 'u' ) ],
    [ CGI->new( { u => 'm' } ), 0 ],
    [ CGI->new( { u => 'http://mixi.jp' } ), 1 ]
);

check(
    'UIntField',
    [ UIntField( name => 'u' ) ],
    [ CGI->new( { u => '-1' } ), 0 ],
    [ CGI->new( { u => 'abc' } ), 0 ],
    [ CGI->new( { u => '3' } ), 1 ]
);

check(
    'IntField',
    [ IntField( name => 'u' ) ],
    [ CGI->new( { u => '1.2' } ), 0 ],
    [ CGI->new( { u => '-1' } ), 1 ],
    [ CGI->new( { u => 'abc' } ), 0 ],
    [ CGI->new( { u => '3' } ), 1 ]
);

check(
    'ChoiceField',
    [ ChoiceField( name => 'u', choices => [a => 'b', c => 'd'] ) ],
    [ CGI->new( { u => 'a' } ), 1 ],
    [ CGI->new( { u => 'd' } ), 0 ],
    [ CGI->new( { u => 'ad' } ), 0 ],
);

check(
    'ChoiceField',
    [ ChoiceField( name => 'u', choices => [a => 'a', b => 'b'] ) ],
    [ CGI->new( { u => 'a' } ), 1 ],
    [ CGI->new( { u => [qw/a b/] } ), 1 ],
    [ CGI->new( { u => [qw/a c/] } ), 0 ],
);

check(
    'DateField',
    [ DateField( name => 'birthdate', years => [2000..2004], required => 1 ) ],
    [ CGI->new( { } ), 0 ],
    [ CGI->new( {
        'birthdate_year'    => 2004,
        'birthdate_month'   => 10,
        'birthdate_day'     => 3,
    } ), 1 ],
);

done_testing;
