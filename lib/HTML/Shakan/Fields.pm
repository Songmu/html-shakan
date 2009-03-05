package HTML::Shakan::Fields;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(
    TextField
    EmailField
    URLField

    PasswordField

    FileField
    ImageField

    ChoiceField

    DateField
);

# DateField
# DateTimeField
# UIntField
# ImageField
# TimeField

sub _push_constraints {
    my ($field, $constraint) = @_;
    push @{$field->{constraints}}, $constraint;
    $field;
}

sub _base {
    my %args = @_;
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

1;
