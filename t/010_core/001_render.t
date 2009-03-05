use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 5;
use CGI;

do {
    my $form = HTML::Shakan->new(
        request => CGI->new,
        fields => [],
    );
    is $form->render, '';
};
do {
    my $form = HTML::Shakan->new(
        request => CGI->new,
        fields => [
            TextField(name => 'yay', label => 'foo')
        ],
    );
    is $form->render, '<label for="id_yay">foo</label><input id="id_yay" type="text" />';
};

do {
    my $form = HTML::Shakan->new(
        request => CGI->new,
        fields => [ ],
    );
    is $form->renderer->render_field(
        $form, PasswordField( name => 'yay', label => 'foo', id => 'id_yay' )
      ),
      '<input id="id_yay" type="password" />';
    is $form->renderer->render_field(
        $form, EmailField( name => 'yay', label => 'foo', id => 'id_yay' )
      ),
      '<input id="id_yay" type="text" />';
};

do {
    my $form = HTML::Shakan->new(
        request => CGI->new({yay => 'hoge<>'}),
        fields => [ ],
    );
    is $form->renderer->render_field(
        $form, TextField( name => 'yay', label => 'foo<>', id => 'id_yay')
      ),
      '<input id="id_yay" type="text" value="hoge&lt;&gt;" />', 'fillin';
}

