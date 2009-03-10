package HTML::Shakan::Field;
use Any::Moose;
use HTML::Shakan::Utils;

has id => (
    is => 'rw',
    isa => 'Str',
    trigger => sub {
        my ($self, $id) = @_;
        $self->{attr}->{id} = $id;
    },
);

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    trigger  => sub {
        my ( $self, $name ) = @_;
        $self->{attr}->{name} = $name;
    },
);

has value => (
    is       => 'rw',
    isa      => 'Str',
    required => 0,
    trigger  => sub {
        my ( $self, $value ) = @_;
        $self->{attr}->{value} = $value;
    },
);

has filters => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { +[] }
);

has widget => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has attr => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
        +{}
    },
);

has label => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { shift->name }
);

has required => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has inflator => (
    is  => 'ro',
    isa => 'Object',
);

has custom_validation => (
    is => 'ro',
    isa => 'CodeRef',
);

has constraints => (
    is  => 'ro',
    isa => 'ArrayRef',
    default => sub { +[] },
);

sub add_constraint {
    my ($self, @constraint) = @_;
    push @{$self->{constraints}}, @constraint;
    $self; # method chain
}

has complex_constraints => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { +[] },
);

sub add_complex_constraint {
    my ($self, @constraints) = @_;
    push @{$self->{complex_constraints}}, @constraints;
    $self; # method chain
}

sub get_constraints {
    my $self = shift;

    my @rule = @{$self->{constraints}};
    if ($self->required) {
        push @rule, 'NOT_NULL';
    }
    return (
        $self->name => \@rule,
        @{ $self->complex_constraints },
    );
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Field - base class for field object

=head1 ATTRIBUTES

=over 4

=item id

the 'id' attribute for the html elements.

=item name

the 'name' attribute for the html elements.

=item value

the 'value' attribute for the html elements.

=item filters

parameter filters.

=item widget

type of widget.

=item attr

hashref about the miscellaneous attributes.

=item label

label for this field.

=item required

is this field's value required?

=item custom_validation

    TextField(
        name => 'id',
        custom_validation => sub {
            my ($form, $field) = @_;
            if (is_reserved_id($form->param($field->name))) {
                $form->set_error($field->name() => 'reserved');
            }
        }
    )

custom validation callback

=item constraints

constraints for FormValidator::Lite.

=back

=head1 AUTHORS

tokuhirom

