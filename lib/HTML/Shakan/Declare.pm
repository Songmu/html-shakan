package HTML::Shakan::Declare;
use strict;
use warnings;
use parent 'Exporter';
use HTML::Shakan ();

our @EXPORT = qw(form get);

sub import {
    my $class = shift;
    __PACKAGE__->export_to_level(1);
    HTML::Shakan::Fields->export_to_level(1);
}

our $FORMS;
sub form ($@) { ## no critic.
    my ($name, @fields) = @_;
    my $pkg = caller(0);
    $FORMS->{$pkg}->{$name} = \@fields;
}

sub get {
    my ($class, $name, %args) = @_;
    $class = ref $class || $class;
    return HTML::Shakan->new(
        fields => $FORMS->{$class}->{$name},
        %args,
    );
}

1;
__END__

=head1 NAME

HTML::Shakan::Declare - declare the form

=head1 SYNOPSIS

    # declare
    {
        package My::Form;
        use HTML::Shakan::Declare;

        form 'add' => (
            TextField(
                name     => 'name',
                required => 1,
            ),
            TextField(
                name     => 'email',
                required => 1,
            ),
        );
    }

    # use it
    {
        my $form = My::Form->get(
            'add' => (
                request => CGI->new,
            )
        );
        $form->render;
    }

=head1 DESCRIPTION

This module supports to generate form using declare style.

=head1 FUNCTIONS

This module exports L<HTML::Shakan::Fields>'s exported functions and following functions.

=over 4

=item form($name, \@fields)

Register new form named I<$name> with C<<\@fields>>.

=back

=head1 EXPORTED METHODS

=over 4

=item Your::Form::Class->get($name[, %args])

Now, your form class provides I< get > method. This method returns instance of L<HTML::Shakan>.

=back

=head1 AUTHORS

Tokuhiro Matsuno

=head1 SEE ALSO

L<HTML::Shakan>

