use strict;
use warnings;
use CGI;
use HTML::Shakan;
use Test::More tests => 1;

my $form = HTML::Shakan->new(
    request => CGI->new({}),
    fields => [ ],
);
is $form->widgets->render( EmailField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="text" />';
is $form->widgets->render( TextField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="text" />';

