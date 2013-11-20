use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 2;

my $DB = {
    'foo' => {
        'VALID_PASSWORD' => 1,
    },
};

sub gen_form {
    my $q = shift;
    HTML::Shakan->new(
        request => $q,
        fields => [
            TextField(name => 'id'),
            PasswordField(name => 'pw'),
        ],
        custom_validation => sub {
            my $form = shift;
            if ($form->is_valid && !$DB->{$form->param('id')}->{$form->param('pw')}) {
                $form->set_error('login' => 'failed');
            }
        },
    );
}

my $f1 = gen_form(
    query({
        id => 'foo',
        pw => 'VALID_PASSWORD',
    })
);
ok $f1->is_valid(), 'valid';

my $f2 = gen_form(
    query({
        id => 'foo',
        pw => 'INVALID_PASSWORD',
    })
);
ok ! $f2->is_valid(), 'invalid';

