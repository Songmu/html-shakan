use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More;

subtest 'add fields' => sub {
    my $form = HTML::Shakan->new(request => query, fields => []);
    is scalar(@{$form->fields()}), 0, 'empty form';
    $form->append_field(TextField(name => 'foo'));
    ok $form, 'append field';
    is scalar(@{$form->fields()}), 1, '1 field in form';
    $form->prepend_field(TextField(name => 'bar'));
    ok $form, 'prepend field';
    is scalar(@{$form->fields()}), 2, '2 fields in form';
};

subtest 'fields order' => sub {
    my $form = HTML::Shakan->new(
            request => query,
            fields  => [TextField(name => 'bar'),],
        );
    is scalar(@{$form->fields()}), 1, 'initialize form with 1 field';
    $form->prepend_field(TextField(name => 'foo'));
    ok $form, 'prepend field "foo"';
    is scalar(@{$form->fields()}), 2, '2 fields';
    is $form->fields->[0]->name, 'foo', 'foo first';
    is $form->fields->[1]->name, 'bar', 'bar second';
    $form->append_field(TextField(name => 'baz'));
    ok $form, 'append field "baz"';
    is scalar(@{$form->fields()}), 3, '3 fields';
    is $form->fields->[0]->name, 'foo', 'foo first';
    is $form->fields->[1]->name, 'bar', 'bar second';
    is $form->fields->[-1]->name, 'baz', 'baz last';
};

done_testing;
