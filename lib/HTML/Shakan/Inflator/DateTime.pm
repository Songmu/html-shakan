package HTML::Shakan::Inflator::DateTime;
use strict;
use warnings;
use DateTime;
use DateTime::Format::HTTP;

sub inflate {
    my ($self, $opt, $val) = @_;

    my $dt = DateTime::Format::HTTP->parse_datetime($val);
    if (my $tz = $opt->{time_zone}) {
        $dt->set_time_zone($tz);
    }
    return $dt;
}

1;
__END__

=head1 NAME

HTML::Shakan::Inflator::DateTime - inflate field value to DateTime instance

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<DateTime>

