package HTML::Shakan::Filter::HTMLScrubber;
use strict;
use warnings;
use Mouse;
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

no Mouse;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

HTML::Shakan::Filter::HTMLScrubber - HTML::Scrubber filter

=head1 SYNOPSIS

    TextField(name => 'body', filters => [qw/HTMLScrubber/])

=head1 DESCRIPTION

remove scripts from this field's value.

=head1 AUTHORS

Tokuhiro Matsuno

=head1 SEE ALSO

L<HTML::Scrubber>

