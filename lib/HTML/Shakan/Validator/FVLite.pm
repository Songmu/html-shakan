package HTML::Shakan::Validator::FVLite;
use Any::Moose;
use FormValidator::Lite 'Email', 'URL';
with 'HTML::Shakan::Role::Validator';

has 'fvl' => (
    is => 'ro',
    isa => 'FormValidator::Lite',
    lazy => 1,
    default => sub { FormValidator::Lite->new(shift->form->request) }
);

sub is_valid {
    my $self = shift;

    $self->fvl->check(
        map { $_->{name} => $_->{constraints}||[] }
        @{$self->form->fields}
    );
    $self->fvl->is_valid() ? 1 : 0;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
