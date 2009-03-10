use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 2;
use CGI;

sub check {
    my $q = shift;
    my $form = HTML::Shakan->new(
        request => $q,
        fields  => [
            Duplication(
                'name' => (
                    TextField( name => 'a' ),
                    TextField( name => 'b' ),
                )
            ),
        ],
    );
    $form->is_valid;
}

is check(CGI->new({a => 1, b => 1})), 1;
is check(CGI->new({a => 1, b => 2})), 0;

