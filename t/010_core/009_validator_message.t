use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 2;

do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [
            TextField(
                name => 'name',
                required => 1,
                label => 'Your name',
            )
        ],
    );
    $form->load_function_message('en');
    is join('', $form->get_error_messages()), 'please input Your name';

    $form->set_message('name.not_null' => 'pleeease input yourrr name');
    is join('', $form->get_error_messages()), 'pleeease input yourrr name';
};

