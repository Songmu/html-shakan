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
    ChoiceField
);

# DateField
# DateTimeField
# UIntField
# ImageField
# TimeField

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
    my $f = TextField(@_);
    push @{$f->{constraints}}, 'EMAIL_LOOSE';
    $f;
}

sub URLField {
    my $f = TextField(@_);
    push @{$f->{constraints}}, 'HTTP_URL';
    $f;
}

sub PasswordField {
    _input(type => 'password', @_);
}

sub FileField {
    _input(type => 'file', @_);
}

sub ChoiceField {
    _base( widget => 'select', @_ );
}

1;
