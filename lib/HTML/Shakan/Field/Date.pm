package HTML::Shakan::Field::Date;
use Any::Moose;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'date'
);

has years => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;
