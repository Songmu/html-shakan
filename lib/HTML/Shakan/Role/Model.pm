package HTML::Shakan::Role::Model;
use strict;
use warnings;
use Any::Moose '::Role';

requires 'create', 'update', 'fill';

has 'form' => (
    is  => 'rw',
    isa => 'HTML::Shakan',
);

1;
