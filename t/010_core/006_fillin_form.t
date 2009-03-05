use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 1;
use CGI;

do {
    my $form = HTML::Shakan->new(
        request => CGI->new({yay => 3}),
        fields => [
            TextField(name => 'yay')
        ],
    );
    is $form->render, '<input id="id_yay" name="yay" type="text" value="3" />';
};

