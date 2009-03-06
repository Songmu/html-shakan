package HTML::Shakan::Field::Choice;
use Any::Moose;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'select'
);

has choices => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;
