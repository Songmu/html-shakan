use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 1;
use CGI;

do {
    my $form = HTML::Shakan->new(
        request => CGI->new,
        fields => [
            TextField(name => 'yay', label => 'foo1'),
            TextField(name => 'yoy', label => 'foo2'),
            TextField(name => 'ymy', label => 'foo3'),
        ],
    );
    is $form->render_field('yoy'), '<input name="yoy" type="text" />';
};

