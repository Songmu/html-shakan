use strict;
use warnings;
use CGI;
use HTML::Shakan;
use Test::More tests => 14;

sub trim {
    local $_ = shift;
    $_ =~ s/\n$//;
    $_;
}

my $form = HTML::Shakan->new(
    request => CGI->new({}),
    fields => [ ],
);
is $form->widgets->render( $form, EmailField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( $form, TextField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( $form, UIntField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( $form, IntField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( $form, URLField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="text" />';
is $form->widgets->render( $form, PasswordField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="password" />';
is $form->widgets->render( $form, FileField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="file" />';
is $form->widgets->render( $form, ImageField( name => 'foo', id => 'name_field' ) ), '<input id="name_field" name="foo" type="file" />';
is $form->widgets->render( $form, TextField( name => 'foo', id => 'name_field', widget => 'textarea' ) ), '<textarea id="name_field" name="foo"></textarea>';

# choices-field + select-widgets
is $form->widgets->render( $form, ChoiceField( name => 'foo', id => 'name_field', choices => [] ) ), qq{<select id="name_field" name="foo">\n</select>};
is $form->widgets->render( $form, ChoiceField( name => 'foo', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), trim(<<'...');
<select id="name_field" name="foo">
<option value="a">1</option>
<option value="b">2</option>
<option value="c">3</option>
</select>
...

# choices-field + radio-widgets
is $form->widgets->render( $form, ChoiceField( widget => 'radio', name => 'foo', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), trim(<<'...');
<ul>
<li><label><input id="id_foo_0" name="foo" type="radio" value="a" />1</label></li>
<li><label><input id="id_foo_1" name="foo" type="radio" value="b" />2</label></li>
<li><label><input id="id_foo_2" name="foo" type="radio" value="c" />3</label></li>
</ul>
...

# choices-field + checkbox-widgets
is $form->widgets->render( $form, ChoiceField( widget => 'checkbox', name => 'bar', id => 'name_field', choices => ['a' => 1, 'b' => 2, 'c' => 3] ) ), trim(<<'...');
<ul>
<li><label><input id="id_bar_0" name="bar" type="checkbox" value="a" />1</label></li>
<li><label><input id="id_bar_1" name="bar" type="checkbox" value="b" />2</label></li>
<li><label><input id="id_bar_2" name="bar" type="checkbox" value="c" />3</label></li>
</ul>
...

# date field
is $form->widgets->render( $form, DateField( name => 'birthdate', years => [2000..2003] ) ), trim(<<'...');
<span>
<select name="birthdate_year">
<option value="2000">2000</option>
<option value="2001">2001</option>
<option value="2002">2002</option>
<option value="2003">2003</option>
</select>
<select name="birthdate_month">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select>
<select name="birthdate_day">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>
</span>
...

