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

    Duplication
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
    HTML::Shakan::Field::File->new(@_);
}

sub ImageField {
    FileField(@_)->add_constraint(['FILE_MIME' => qr{image/.+}]);
}

sub ChoiceField {
    HTML::Shakan::Field::Choice->new( @_ );
}

sub DateField {
    HTML::Shakan::Field::Date->new( @_ );
}

sub Duplication {
    my ($name, $f1, $f2) = @_;
    Carp::croak('missing args. Usage: Duplication(name, field1, field2)') unless @_ == 3;
    $f1->add_complex_constraint(
        +{ $name => [ $f1->name(), $f2->name() ] } => [ 'DUPLICATION' ]
    );
    return ($f1, $f2);
}

1;
__END__

=head1 NAME

HTML::Shakan::Fields - fields

=head1 DESCRIPTION

This module exports some functions, that generates a instance of HTML::Field::*.

If you want to know the details, please look the source :)

=head1 FUNCTIONS 

=over 4

=item TextField(name => 'foo')

create a instance of HTML::Shakan::Input.

This is same as HTML::Shakan::Input->new(name => 'foo', type => 'text', @_);

=item EmailField(name => 'email')

TextField() + EMAIL_LOOSE constraint.

=item URLField(name => 'url')

TextField() + HTTP_URL constraint

=item UIntField(name => 'i')

TextField() + UINT constraint

=item IntField(name => 'i')

TextField() + INT constraint

=item PasswordField(name => 'pw')

define <input type="password" /> field

=item FileField(name => 'file')

define <input type="fiel" /> field

=item ImageField(name => 'image')

FileField + FILE_MIME=image/* constraint

=item ChoiceField(name => 'interest', choices => [qw/moose mouse exporter/])

selector field.

=item DateField(name => 'birthdate')

date input field.

=item Duplication('mail' => EmailField(), EmailField())

both field contains same value?

=back

=head1 AUTHORS

Tokuhiro Matsuno(tokuhirom)

=head1 SEE ALSO

L<HTML::Shakan>

