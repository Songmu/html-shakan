package HTML::Shakan::Field::Date;
use Any::Moose;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'date'
);

has years => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 0,
);

sub BUILD {
    my $self = shift;
    $self->add_constraint('DATE');
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Field::Date - date field

=head1 DESCRIPTION

date field specific class.

=head1 SEE ALSO

L<HTML::Shakan>

