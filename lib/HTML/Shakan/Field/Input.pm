package HTML::Shakan::Field::Input;
use strict;
use warnings;
use Mouse;
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

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Field::Input - <input /> field

=head1 DESCRIPTION

This module provides the <input /> field object.

=head1 ATTRIBUTE

=over 4

=item type

<input type="XXX" /> attribute.

=back

=head1 SEE ALSO

L<HTML::Shakan>

