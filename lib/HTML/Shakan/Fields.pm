package HTML::Shakan::Fields;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(
    TextField
    EmailField
    URLField
    UIntField
    IntField

    PasswordField

    FileField
    ImageField

    ChoiceField

    DateField
);

# DateTimeField
# ImageField
# TimeField

sub _push_constraints {
    my ($field, $constraint) = @_;
    push @{$field->{constraints}}, $constraint;
    $field;
}

sub _base {
    my %args = @_;
    $args{name} or die "missing name attribute for field";
    if (delete $args{required}) {
        push @{$args{constraints}}, 'NOT_NULL';
    }
    \%args;
}

sub _input {
    _base( widget => 'input', @_ );
}

sub TextField {
    _input(type => 'text', @_);
}

sub EmailField {
    _push_constraints(TextField(@_), 'EMAIL_LOOSE');
}

sub URLField {
    _push_constraints(TextField(@_), 'HTTP_URL');
}

sub UIntField {
    _push_constraints(TextField(@_), 'UINT');
}

sub IntField {
    _push_constraints(TextField(@_), 'INT');
}

sub PasswordField {
    _input(type => 'password', @_);
}

sub FileField {
    _input(type => 'file', @_);
}

sub ImageField {
    _push_constraints(FileField(@_), 'VALID_IMAGE');
}

sub ChoiceField {
    _base( widget => 'select', @_ );
}

sub DateField {
    my $f = _base( widget => 'date', @_ );
    $f->{years} or die "missing years";
    $f;
}

1;
