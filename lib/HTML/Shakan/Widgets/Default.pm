package HTML::Shakan::Widgets::Default;
use Any::Moose;
with 'HTML::Shakan::Role::Widgets';
use HTML::Entities 'encode_entities';

sub render {
    my ($self, $field) = @_;

    my %field = %$field;
    my $type = delete $field{widget} or die "invalid field: missing widget name";
    $self->can("widget_${type}")->(
        $self, \%field
    );
}

sub _attr {
    my %attr = @_;
    my @ret;
    for my $key (sort keys %attr) {
        push @ret, sprintf(q{%s="%s"}, $key, encode_entities($attr{$key}));
    }
    join ' ', @ret;
}

sub widget_input {
    my ($self, $field) = @_;

    my @t;
    # TODO: id should be optional
    # TODO: name=?
    push @t, sprintf(q{<input id="%s" type="%s" }, $field->{id}, $field->{type}||'');
    if (my $value = $self->form->fillin_param($field->{name})) {
        push @t, sprintf(q{value="%s" }, encode_entities($value));
    }
    push @t, "/>";
    return join '', @t;
}

sub widget_select {
    my ($select, $field) = @_;

    my $choices = delete $field->{choices};

    my @t;
    push @t, sprintf(q{<select %s>}, _attr(%$field));
    while (my ($a, $b) = splice @$choices, 0, 2) {
        push @t, sprintf(q{<option value="%s">%s</option>}, $a, $b);
    }
    push @t, q{</select>};
    return join '', @t;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
