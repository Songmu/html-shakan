use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 2;
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
    is $form->render, '<label for="id_yay">foo</label><input id="id_yay" name="yay" type="text" />';
};

