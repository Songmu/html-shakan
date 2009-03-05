package HTML::Shakan::Widgets::Default;
use Any::Moose;
use HTML::Entities 'encode_entities';

sub render {
    my ($self, $type, $form, $field) = @_;
    $self->can("widget_${type}")->(
        $self, $form, $field
    );
}

sub widget_input {
    my ($self, $form, $field) = @_;

    my @t;
    push @t, sprintf(q{<input id="%s" type="%s" }, $field->{id}, $field->{type}||'');
    if (my $value = $form->fillin_param($field->{name})) {
        push @t, sprintf(q{value="%s" }, encode_entities($value));
    }
    push @t, "/>";
    return join '', @t;
}

sub widget_select {
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
