package HTML::Shakan::Filter::HTMLScrubber;
use Any::Moose;
use HTML::Scrubber;

has scrubber => (
    is      => 'ro',
    isa     => 'HTML::Scrubber',
    default => sub { HTML::Scrubber->new() },
);

sub filter {
    my ($self, $val) = @_;
    $self->scrubber->scrub($val);
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
