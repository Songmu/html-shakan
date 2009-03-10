use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 2;
use CGI;

do {
    my $form = HTML::Shakan->new(
        request => CGI->new,
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

