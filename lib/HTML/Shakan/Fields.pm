package HTML::Shakan::Fields;
use strict;
use warnings;
use parent 'Exporter';
use Carp ();

our @EXPORT = qw(
    TextField
    EmailField
    URLField
    UIntField
    IntField

    PasswordField

    HiddenField
    TextAreaField

    FileField
    ImageField

    ChoiceField

    DateField

    Duplication
);

# DateTimeField
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

sub HiddenField {
    _input(type => 'hidden', value => '', @_);
}

sub TextAreaField {
    HTML::Shakan::Field->new(widget => 'textarea', @_);
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

=encoding utf8

=head1 NAME

HTML::Shakan::Fields - fields

=head1 DESCRIPTION

This module exports some functions, that generates a instance of HTML::Field::*.

If you want to know the details, please look the source :)

=head1 FUNCTIONS 

=over 4

=item C<< TextField(name => 'foo') >>

create a instance of HTML::Shakan::Input.

This is same as HTML::Shakan::Input->new(name => 'foo', type => 'text', @_);

=item C<< EmailField(name => 'email') >>

TextField() + EMAIL_LOOSE constraint.

=item C<< URLField(name => 'url') >>

TextField() + HTTP_URL constraint

=item C<< UIntField(name => 'i') >>

TextField() + UINT constraint

=item C<< IntField(name => 'i') >>

TextField() + INT constraint

=item C<< PasswordField(name => 'pw') >>

define <input type="password" /> field

=item C<< HiddenField(name => 'pw') >>

define <input type="hidden" /> field

=item C<< TextAreaField(name => 'pw') >>

define <textarea></textarea> field

=item C<< FileField(name => 'file') >>

define <input type="file" /> field

=item C<< ImageField(name => 'image') >>

FileField + FILE_MIME=image/* constraint

=item C<< ChoiceField(name => 'interest', choices => [1 => 'moose', 2 => 'mouse', 3 => 'exporter']) >>

selector field.

=item C<< DateField(name => 'birthdate') >>

date input field.

=item C<< Duplication('mail' => EmailField(), EmailField()) >>

both field contains same value?

=back

=head1 AUTHORS

Tokuhiro Matsuno(tokuhirom)

=head1 SEE ALSO

L<HTML::Shakan>

use Params::Validate ':all';
