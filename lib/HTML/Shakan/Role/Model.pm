package HTML::Shakan::Role::Model;
use strict;
use warnings;
use Mouse::Role;

requires 'create', 'update', 'fill';

has 'form' => (
    is  => 'rw',
    isa => 'HTML::Shakan',
);

1;
