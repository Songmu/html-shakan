package HTML::Shakan::Renderer::HTML;
use strict;
use warnings;
use Mouse;
use HTML::Shakan::Utils;

has 'id_tmpl' => (
    is => 'ro',
    isa => 'Str',
    default => 'id_%s',
);

sub render {
    my ($self, $form) = @_;

    my @res;
    for my $field ($form->fields) {
        unless ($field->id) {
            $field->id(sprintf($self->id_tmpl(), $field->{name}));
        }
        if ($field->label) {
            push @res, sprintf( q{<label for="%s">%s</label>},
                $field->{id}, encode_entities( $field->{label} ) );
        }
        push @res, $form->widgets->render( $form, $field );
    }
    join '', @res;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 DESCRIPTION

simple HTML renderer for HTML::Shakan.
