use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 8;

# -------------------------------------------------------------------------
# submitted
do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [
            TextField(name => 'yay')
        ],
    );
    is $form->submitted(), 0, "not submit";
};
do {
    my $form = HTML::Shakan->new(
        request => query({yay => 1}),
        fields => [
            TextField(name => 'yay')
        ],
    );
    is $form->submitted(), 1, 'ok. you submit';
};

# -------------------------------------------------------------------------
# submitted_and_valid
do {
    my $form = HTML::Shakan->new(
        request => query({yay => 1}),
        fields => [
            TextField(name => 'yay'),
            TextField(required => 1, name => 'bay'),
        ],
    );
    is $form->submitted(), 1, 'ok. you submit';
    ok ! $form->submitted_and_valid(), 'but not valid';
    ok ! $form->is_valid(), 'not valid';
};

do {
    my $form = HTML::Shakan->new(
        request => query({yay => 1, bay => 1}),
        fields => [
            TextField(name => 'yay'),
            TextField(required => 1, name => 'bay'),
        ],
    );
    is $form->submitted(), 1, 'ok. you submit';
    ok $form->submitted_and_valid(), 'and valid';
    ok $form->is_valid(), 'ofcourse valid';
};
