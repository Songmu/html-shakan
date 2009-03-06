package HTML::Shakan::Fields;
use strict;
use warnings;
use base 'Exporter';
use Params::Validate ':all';
use Carp ();

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

sub _input {
    HTML::Shakan::Field::Input->new( @_ );
}

sub TextField {
    _input(type => 'text', @_);
}

sub EmailField {
    TextField(@_)->add_constraint('EMAIL_LOOSE');
}

sub URLField {
    TextField(@_)->add_constraint('HTTP_URL');
}

sub UIntField {
    TextField(@_)->add_constraint('UINT');
}

sub IntField {
    TextField(@_)->add_constraint('INT');
}

sub PasswordField {
    _input(type => 'password', @_);
}

sub FileField {
    _input(type => 'file', @_);
}

sub ImageField {
    FileField(@_)->add_constraint('IMAGE');
}

sub ChoiceField {
    HTML::Shakan::Field::Choice->new( @_ );
}

sub DateField {
    HTML::Shakan::Field::Date->new( @_ );
}

1;
