package HTML::Shakan::Field::Date;
use Any::Moose;
extends 'HTML::Shakan::Field';

has '+widget' => (
    default => 'date'
);

has years => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

for my $key (qw/year month day/) {
    has "name_$key" => (
        is => 'ro',
        isa => 'Str',
        lazy => 1,
        default => sub { shift->name . "_$key" }
    );
}

override 'get_constraints' => sub {
    my $self = shift;
    my ($name, $constraints) = super();

    $name = {date => [map { $self->$_ } qw/name_year name_month name_day/ ]};

    return (
        $name => [@$constraints, 'DATE'],
    );
};

sub field_filter {
    my ($self, $form, $params) = @_;

    # todo: inflate here?
    for my $key (qw/name_year name_month name_day/) {
        my $v = $form->request->param($self->$key);
        if (defined $v) {
            $params->{$self->$key} = $v;
        }
    }
    $params;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
