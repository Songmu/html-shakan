package HTML::Shakan::Widgets::Default;
use Any::Moose;
with 'HTML::Shakan::Role::Widgets';
use HTML::Entities 'encode_entities';

sub render {
    my ($self, $field) = @_;
    my $type = $field->{widget} or die "invalid field: missing widget name";
    $self->can("widget_${type}")->(
        $self, $field
    );
}

sub widget_input {
    my ($self, $field) = @_;

    my @t;
    push @t, sprintf(q{<input id="%s" type="%s" }, $field->{id}, $field->{type}||'');
    if (my $value = $self->form->fillin_param($field->{name})) {
        push @t, sprintf(q{value="%s" }, encode_entities($value));
    }
    push @t, "/>";
    return join '', @t;
}

sub widget_select {
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
