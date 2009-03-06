package HTML::Shakan::Validator::FVLite;
use Any::Moose;
use FormValidator::Lite 'Email', 'URL';
with 'HTML::Shakan::Role::Validator';

has 'fvl' => (
    is => 'ro',
    isa => 'FormValidator::Lite',
    lazy => 1,
    default => sub { FormValidator::Lite->new(shift->form->_filtered_param) }
);

sub is_valid {
    my $self = shift;

    my @c;
    for my $field (@{ $self->form->fields }) {
        my $rule = $field->{constraints};
        if ($field->required) {
            push @$rule, 'NOT_NULL';
        }
        push @c, (
            $field->name => $rule,
        );
    }

    $self->fvl->check(@c);
    $self->fvl->is_valid() ? 1 : 0;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
