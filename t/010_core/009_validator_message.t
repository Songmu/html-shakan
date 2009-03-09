use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 1;
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
};

