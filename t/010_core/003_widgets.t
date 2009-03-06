use strict;
use warnings;
use CGI;
use HTML::Shakan;
use Test::More tests => 10;

sub trim {
    local $_ = shift;
    $_ =~ s/\n$//;
    $_;
}

my $form = HTML::Shakan->new(
    request => CGI->new({}),
    fields => [ ],
);
is $form->widgets->render( EmailField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( TextField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( UIntField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( URLField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( PasswordField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="password" />';
is $form->widgets->render( FileField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="file" />';
is $form->widgets->render( ImageField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="file" />';

# choices-field + select-widgets
is $form->widgets->render( ChoiceField( name => 'foo', id => 'name_field' ) ), '<select id="name_field" name="foo"></select>';
is $form->widgets->render( ChoiceField( name => 'foo', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), '<select id="name_field" name="foo"><option value="a">1</option><option value="b">2</option><option value="c">3</option></select>';

# choices-field + radio-widgets
is $form->widgets->render( ChoiceField( widget => 'radio', name => 'foo', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), trim(<<'...');
<ul>
<li><label><input type="radio" value="a" />1</label></li>
<li><label><input type="radio" value="b" />2</label></li>
<li><label><input type="radio" value="c" />3</label></li>
</ul>
...

