package HTML::Shakan::Field::File;
use strict;
use warnings;
use Mouse;
extends 'HTML::Shakan::Field::Input';

has '+type' => (
    default => 'file',
);

sub field_filter {
    my ($self, $form, $params) = @_;
    $form->uploads->{$self->name} = FormValidator::Lite::Upload->new(
        $form->request, $self->name,
    );
    $params;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Field::File - file upload field

=head1 DESCRIPTION

file upload field

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<HTML::Shakan>
