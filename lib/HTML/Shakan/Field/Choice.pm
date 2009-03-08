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

override 'get_constraints' => sub {
    my $self = shift;
    my ($name, $constraints) = super();

    # NOTE: don't break $constraints itself. this is a ref. to original rule.
    return (
        $name => [
            @$constraints,
            ['CHOICE' => $self->choices]
        ]
    );
};

no Any::Moose;
__PACKAGE__->meta->make_immutable;
