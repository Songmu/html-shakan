package HTML::Shakan::Field::Input;
use Any::Moose;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'input',
);

has type => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);
sub BUILD {
    my $self = shift;
    $self->attr->{type} = $self->type;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
