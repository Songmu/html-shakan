package HTML::Shakan::Renderer::HTML;
use Any::Moose;
use HTML::Entities 'encode_entities';

has 'id_tmpl' => (
    is => 'ro',
    isa => 'Str',
    default => 'id_%s',
);

sub render {
    my ($self, $form) = @_;

    my $res = '';
    for my $field (@{$form->fields}) {
        $res .= $self->render_field($form => $field);
    }
    $res;
}

sub render_field {
    my ($self, $form, $field) = @_;
    my @t;
    my $id = $field->{id} || sprintf($self->id_tmpl(), $field->{name});
    if ($field->{label}) {
        push @t,
            sprintf( q{<label for="%s">%s</label>},
            $id, encode_entities( $field->{label} ) );
    }
    push @t, sprintf(q{<input id="%s" type="%s" }, $id, $field->{type}||'');
    if (my $value = $form->fillin_param($field->{name})) {
        push @t, sprintf(q{value="%s" }, encode_entities($value));
    }
    push @t, "/>";
    return join '', @t;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 DESCRIPTION

simple html renderer for html::shakan.
