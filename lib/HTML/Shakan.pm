package HTML::Shakan;
use Any::Moose;
our $VERSION = '0.01';
use HTML::Shakan::Renderer::HTML;
use HTML::Shakan::Fields;
use Any::Moose '::Util::TypeConstraints';
use Carp ();

sub import {
    HTML::Shakan::Fields->export_to_level(1);
}

has validator => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        Any::Moose::load_class('HTML::Shakan::Validator::FVLite');
        HTML::Shakan::Validator::FVLite->new(form => $self);
    },
);
sub is_valid {
    my $self = shift;
    Carp::croak('request is required for validation') unless $self->request;

    $self->validator->is_valid($self);
}

has instance => (
    is => 'rw',
    isa => 'Object',
);

has model => (
    is => 'rw',
    isa => 'Object',
);

has renderer => (
    is => 'rw',
    isa => 'Object',
    default => sub {
        HTML::Shakan::Renderer::HTML->new();
    },
);
sub render {
    my $self = shift;
    $self->renderer()->render($self);
}

sub fillin_param {
    my ($self, $key) = @_;

    if ($self->instance) {
        return $self->model->fillin_param($key);
    } elsif ($self->request) {
        return $self->request->param($key);
    } else {
        return;
    }
}

has fields => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

has request => (
    is       => 'ro',
    isa      => 'Object',
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan - form html generator/validator

=head1 SYNOPSIS

    use HTML::Shakan;

    sub form {
        my $req = shift;
        HTML::Shakan->new(
            fields => [ @_ ],
            model => 'DataModel',
            renderer => 'Default',
            request => $req,
        );
    }
    sub edit {
        my $req = shift;
        my $form = form(
            $req => (
                TextField(name => 'name', label => 'Your name', filter => [qw/WhiteSpace/]),
                EmailField(name => 'email', label => 'Your email'),
            )
        );
        if ($req->submitted_and_valid) {
            $form->model->update;
            redirect('edit_thanks');
        }
        render(form => $form);
    }
    sub add {
        my $req = shift;
        my $form = form(
            $req => (
                TextField(name => 'name', label => 'Your name'),
                EmailField(name => 'email', label => 'Your email'),
            )
        );
        if ($req->submitted_and_valid) {
            $form->model->insert;
            redirect('edit_thanks');
        }
        render(form => $form);
    }

    # in your template
    <? if ($form->has_error) ?><div class="error"><?= $form->error_message ?></div><? } ?>
    <form method="post" action="add">
    <?= $form->render() ?>
    </form>

=head1 DESCRIPTION

HTML::Shakan is yet another form generator.

THIS IS BETA.API WILL CHANGE.

=head1 What's shakan

Shakan is 左官 in japanese.

If you want to know about shakan, please see L<http://www.konuma-sakan.com/index2.html>

左官 should pronounce 'sakan', formally. but, edokko pronounce 左官 as shakan.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<HTML::FormFu>

ToscaWidgets

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
