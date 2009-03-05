use strict;
use warnings;
use CGI;
use HTML::Shakan;
use Test::More tests => 6;

my $form = HTML::Shakan->new(
    request => CGI->new({}),
    fields => [ ],
);
is $form->widgets->render( EmailField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="text" />';
is $form->widgets->render( TextField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="text" />';
is $form->widgets->render( PasswordField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="password" />';
is $form->widgets->render( FileField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" type="file" />';

is $form->widgets->render( ChoiceField( name => 'foo', id => 'name_field' ) ), '<select id="name_field" name="foo"></select>';
is $form->widgets->render( ChoiceField( name => 'foo', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), '<select id="name_field" name="foo"><option value="a">1</option><option value="b">2</option><option value="c">3</option></select>';

