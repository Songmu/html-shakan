use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 2;

my $RESERVED_ID = {
    'root' => 1,
    'admin' => 1,
};

sub gen_form {
    my $q = shift;
    HTML::Shakan->new(
        request => $q,
        fields => [
            TextField(
                name => 'id',
                custom_validation => sub {
                    my ($form, $field) = @_;
                    if ($RESERVED_ID->{$form->param($field->name)}) {
                        $form->set_error($field->name() => 'reserved');
                    }
                },
            ),
        ],
    );
}

{
    my $f1 = gen_form(
        query({
            id => 'foo',
        })
    );
    ok $f1->is_valid(), 'valid';
}

{
    my $f2 = gen_form(
        query({
            id => 'admin',
        })
    );
    ok ! $f2->is_valid(), 'invalid';
}

