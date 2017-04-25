package HTML::Shakan::Field::Choice;
use strict;
use warnings;

use List::Util 1.32 qw/pairkeys/;

use Mouse;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'select'
);

has choices => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

has 'id_tmpl' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'id_%s_%s',
);

has item_label_class => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_item_label_class',
);

override 'get_constraints' => sub {
    my $self = shift;
    my ($name, $constraints) = super();

    return (
        $name => [
            @$constraints,
            ['CHOICE' => [ pairkeys @{$self->choices} ] ]
        ]
    );
};

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Field::Choice - choice field

=head1 SYNOPSIS

    use HTML::Shakan::Field::Choice;
    HTML::Shakan::Field::Choice->new(
        name => 'pref',
        choices => [
            #value=> label
            tokyo => 'tokyo',
            osaka => 'osaka',
            kyoto => 'kyoto',
        ],
    );

    # or shortcut
    use HTML::Shakan::Fields;
    ChoiceField(
        name => 'pref',
        choices => [
            tokyo => 'tokyo',
            osaka => 'osaka',
            kyoto => 'kyoto',
        ],
    );

    # if you want radio button
    ChoiceField(
        name => 'pref',
        choices => [
            tokyo => 'tokyo',
            osaka => 'osaka',
            kyoto => 'kyoto',
        ],
        widget => 'radio',
    );

    # if you want checkbox
    ChoiceField(
        name => 'pref',
        choices => [
            tokyo => 'tokyo',
            osaka => 'osaka',
            kyoto => 'kyoto',
        ],
        widget => 'checkbox',
    );

=head1 DESCRIPTION

Choice field implementation. This field may show in HTML as C<< <select></select> >> tag.

=head1 base class

HTML::Shakan::Field

=head1 SEE ALSO

L<HTML::Shakan>
