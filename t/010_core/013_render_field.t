use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 1;

do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [
            TextField(name => 'yay', label => 'foo1'),
            TextField(name => 'yoy', label => 'foo2'),
            TextField(name => 'ymy', label => 'foo3'),
        ],
    );
    is $form->render_field('yoy'), '<input name="yoy" type="text" />';
};

