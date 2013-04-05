package HTML::Shakan::Inflator::DateTime;
use strict;
use warnings;
use Mouse;
use DateTime;
use DateTime::Format::HTTP;

has 'time_zone' => (
    is  => 'ro',
    isa => 'Str',
);

sub inflate {
    my ($self, $val) = @_;

    my $dt = DateTime::Format::HTTP->parse_datetime($val);
    if (my $tz = $self->time_zone) {
        $dt->set_time_zone($tz);
    }
    return $dt;
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Inflator::DateTime - inflate field value to DateTime instance

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<DateTime>

