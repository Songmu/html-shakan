package HTML::Shakan::Renderer::HTML;
use Any::Moose;
use HTML::Shakan::Widgets::Default;
use HTML::Entities 'encode_entities';

has 'id_tmpl' => (
    is => 'ro',
    isa => 'Str',
    default => 'id_%s',
);

has 'widgets' => (
    is => 'ro',
    isa => 'Object',
    default => sub { HTML::Shakan::Widgets::Default->new },
);

sub render {
    my ($self, $form) = @_;

    my $res = '';
    for my $field (@{$form->fields}) {
        $field->{id} ||= sprintf($self->id_tmpl(), $field->{name});
        if ($field->{label}) {
            $res .=
                sprintf( q{<label for="%s">%s</label>},
                $field->{id}, encode_entities( $field->{label} ) );
        }
        $res .= $self->render_field($form => $field);
    }
    $res;
}

sub render_field {
    my ($self, $form, $field) = @_;
    my $widget = $field->{widget} or die 'missing widget info';
    $self->widgets->render($widget, $form, $field );
}


no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 DESCRIPTION

simple html renderer for html::shakan.
