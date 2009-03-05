package HTML::Shakan::Fields;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(
    TextField
    EmailField
    PasswordField
    FileField
    ChoiceField
);

# DateField
# DateTimeField
# UIntField
# ImageField
# TimeField

sub _input {
    +{ widget => 'input', @_ };
}

sub TextField {
    _input(type => 'text', @_);
}

sub EmailField {
    my $f = TextField(@_);
    push @{$f->{constraints}}, 'EMAIL_LOOSE';
    $f;
}

sub PasswordField {
    _input(type => 'password', @_);
}

sub FileField {
    _input(type => 'file', @_);
}

sub ChoiceField {
    +{ widget => 'select', @_ };
}

1;
