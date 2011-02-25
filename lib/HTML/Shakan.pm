package HTML::Shakan;
use Any::Moose;
our $VERSION = '0.09';
use Carp ();

use FormValidator::Lite 'Email', 'URL', 'Date', 'File';

use HTML::Shakan::Renderer::HTML;
use HTML::Shakan::Filters;
use HTML::Shakan::Widgets::Simple;
use HTML::Shakan::Fields;
use HTML::Shakan::Field::Input;
use HTML::Shakan::Field::Date;
use HTML::Shakan::Field::Choice;
use HTML::Shakan::Field::File;
use List::MoreUtils 'uniq';
BEGIN {
    if ($ENV{SHAKAN_DEBUG}) {
        require Smart::Comments;
        Smart::Comments->import;
    }
};

sub import {
    HTML::Shakan::Fields->export_to_level(1);
}

has '_fvl' => (
    is => 'ro',
    isa => 'FormValidator::Lite',
    lazy => 1,
    handles => [qw/has_error load_function_message get_error_messages is_error is_valid set_error set_message/],
    default => sub {
        my $self = shift;
        $self->params(); # build laziness data

        FormValidator::Lite->new($self);
    }
);

sub BUILD {
    my $self = shift;

    my $fvl = $self->_fvl;

    # simple check
    $fvl->check(do {
        my @c;
        for my $field (@{ $self->fields }) {
            push @c, $field->get_constraints();
        }
        @c;
    });

    # run custom validation
    if (my $cv = $self->custom_validation) {
        $cv->( $self );
    }
    for my $field ($self->fields) {
        if (my $cv = $field->custom_validation) {
            $cv->($self, $field);
        }
    }

    if ($fvl->is_valid) {
        $self->_inflate_values();
    } else {
        $fvl->set_param_message(
            $self->_set_error_messages()
        );
    }
}

has custom_validation => (
    is => 'ro',
    isa => 'CodeRef',
);

sub _set_error_messages {
    my ($self, ) = @_;

    my %x;
    for my $field ($self->fields) {
        $x{$field->name} = $field->label || $field->name;
    }
    %x;
}

sub _inflate_values {
    my $self = shift;

    # inflate values
    my $params = $self->params;
    for my $field (@{ $self->fields }) {
        if (my $inf = $field->inflator) {
            my $v = $params->{$field->name};
            if (defined $v) {
                $params->{$field->name} = $inf->inflate($v);
            }
        }
    }
}

has 'submitted' => (
    is => 'ro',
    isa => 'Bool',
    lazy => 1,
    builder => '_build_submitted',
);
sub _build_submitted {
    my ($self, ) = @_;

    my $r = $self->request;
    my $submitted_field = (
        scalar
          grep { defined $r->param($_) }
          uniq
          map  { $_->name }
                 $self->fields
    );
    return $submitted_field > 0 ? 1 : 0;
}

sub submitted_and_valid {
    my $self = shift;
    $self->submitted && $self->is_valid;
}

has model => (
    is => 'rw',
    isa => 'Object',
    trigger => sub {
        my ($self, $model) = @_;
        $model->form($self);
        $model;
    },
);

has renderer => (
    is => 'rw',
    isa => 'Object',
    builder => '_build_renderer',
);
sub _build_renderer {
    HTML::Shakan::Renderer::HTML->new();
}
sub render {
    my $self = shift;
    $self->renderer()->render($self);
}

sub render_field {
    my ( $self, $name ) = @_;
    my ( $field, ) = grep { $_->name eq $name } $self->fields;
    return unless $field;
    return $self->widgets->render( $self, $field );
}

sub fillin_param {
    my ($self, $key) = @_;
    $self->fillin_params->{$key};
}
has fillin_params => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $fp = {};
        for my $name ($self->request->param) {
            my @v = $self->request->param($name);
            if (@v) {
                $fp->{$name} = @v==1 ? $v[0] : \@v;
            }
        }
        $fp;
    },
);

has fields => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
    auto_deref => 1,
);

has request => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

has 'widgets' => (
    is => 'ro',
    isa => 'Str',
    default => 'HTML::Shakan::Widgets::Simple',
);

has 'params' => (
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    builder => '_build_params',
);

has 'uploads' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { +{} },
);
sub upload {
    my ($self, $name) = @_;
    $self->uploads->{$name};
}

# code taken from MooseX::Param
sub param {
    my $self = shift;

    my $params = $self->params;

    # if they want the list of keys ...
    return keys %{ $params } if scalar @_ == 0;

    # if they want to fetch a particular key ...
    if (scalar @_ == 1) {
        if (exists $params->{$_[0]}) {
            return $params->{$_[0]};
        } else {
            return; # this behavior is same as cgi.pm(iirc)
        }
    }

    ( ( scalar @_ % 2 ) == 0 )
      || confess "parameter assignment must be an even numbered list";

    my %new = @_;
    while ( my ( $key, $value ) = each %new ) {
        $self->params->{$key} = $value;
    }

    return;
}

sub _build_params {
    my $self = shift;
    my $params = {};
    for my $field (@{$self->fields}) {
        if ($self->widgets->can('field_filter')) {
            # e.g. DateField
            $self->widgets->field_filter($self, $field, $params);
        }
        if ($field->can('field_filter')) {
            # e.g. FileField
            $field->field_filter($self, $params);
        }

        my $name = $field->name;

        my @val = $self->request->param($name);
        if (@val!=0) {
            $params->{$name} = @val==1 ? $val[0] : \@val;

            if (my $filters = $field->{filters}) {
                for my $filter (@{$filters}) {
                    my @val =
                        ( map { HTML::Shakan::Filters->filter( $filter, $_ ) }
                            $self->request->param($name) );
                    $params->{$name} = @val==1 ? $val[0] : \@val;
                }
            }
        }
    }
    $params;
}

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
            request => $req,
            model => 'DataModel',
        );
    }
    sub edit {
        my $req = shift;
        my $row = $model->get('user' => $req->param('id'));
        my $form = form(
            $req => (
                TextField(name => 'name', label => 'Your name', filter => [qw/WhiteSpace/]),
                EmailField(name => 'email', label => 'Your email'),
            ),
        );
        if ($req->submitted_and_valid) {
            $form->model->update($row);
            redirect('edit_thanks');
        } else {
            $form->model->fill($row);
            render(form => $form);
        }
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
            $form->model->insert($model => 'user');
            redirect('edit_thanks');
        }
        render(form => $form);
    }

    # in your template
    <? if ($form->has_error) { ?><div class="error"><?= $form->error_message() ?></div><? } ?>
    <form method="post" action="add">
    <?= $form->render() ?>
    <p><input type="submit" value="add" /></p>
    </form>

=head1 DESCRIPTION

HTML::Shakan is yet another form generator.

THIS IS BETA.API WILL CHANGE.

=head1 ATTRIBUTES

=over 4

=item custom_validation

    form 'login' => (
        fields => [
            TextField(name => 'login_id'),
            PasswordField(name => 'login_pw'),
        ],
        custom_validation => sub {
            my $form = shift;
            if ($form->is_valid && !MyDB->retrieve($form->param('login_id'), $form->param('login_pw'))) {
                $form->set_error('login' => 'failed');
            }
        }
    );

You can set custom validation callback, validates the field set in the form. For example, this is useful for login form.

=item submitted

Returns true if the form has been submitted.

This attribute will return true if a value for any known field name was submitted.

=item has_error

Return true if request has an error.

=item submitted_and_valid

Shorthand for C<< $form->submitted && !$form->has_error >>

=back

=head1 benchmarking

form generation

                     Rate         formfu         shakan shakan_declare
    formfu         1057/s             --           -77%           -84%
    shakan         4695/s           344%             --           -31%
    shakan_declare 6757/s           539%            44%             --

=head1 What's shakan

Shakan is 左官 in Japanese.

If you want to know about shakan, please see L<http://www.konuma-sakan.com/index2.html>

左官 should pronounce 'sakan', formally. but, edokko pronounce 左官 as shakan.

=head1 METHODS

=over 4

=item my $html = $shakan->render(); :Str

Render form.

=item $shakan->render_field($name); :Str

Render partial form named C<<$name>>.

=back

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom  slkjfd gmail.comE<gt>

=head1 SEE ALSO

L<HTML::FormFu>

ToscaWidgets

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
