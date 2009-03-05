package HTML::Shakan::Fields;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT = qw(
    TextField
    EmailField
    PasswordField
    FileField
);

sub _base {
    +{ @_ };
}

sub TextField {
    _base(type => 'text', @_);
}

sub EmailField {
    my $f = TextField(@_);
    push @{$f->{constraints}}, 'EMAIL';
    $f;
}

sub PasswordField {
    _base(type => 'password', @_);
}

sub FileField {
    _base(type => 'file', @_);
}

1;
