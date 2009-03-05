use strict;
use warnings;
use HTML::Shakan;
use Test::More tests => 4;
use CGI;

do {
    my $fields = [
        TextField(
            name        => 'name',
            constraints => [qw/NOT_NULL/]
        ),
    ];

    {
        my $form = HTML::Shakan->new(
            request => CGI->new,
            fields => $fields,
        );
        is $form->is_valid(), 0;
    }
    {
        my $form = HTML::Shakan->new(
            request => CGI->new({name => 'oo'}),
            fields => $fields,
        );
        is $form->is_valid(), 1;
    }
    {
        my $form = HTML::Shakan->new(
            request => CGI->new({email => 'oo'}),
            fields => [
                EmailField(name => 'email')
            ],
        );
        is $form->is_valid(), 0;
    }
    {
        my $form = HTML::Shakan->new(
            request => CGI->new({email => 'oo@example.com'}),
            fields => [
                EmailField(name => 'email')
            ],
        );
        is $form->is_valid(), 1;
    }
};

