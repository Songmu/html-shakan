package HTML::Shakan::Utils;
use strict;
use warnings;
use base qw/Exporter/;

our @EXPORT = qw/encode_entities/;

sub encode_entities {
    local $_ = shift;
    return $_ unless $_;
    s/&/&amp;/g;
    s/>/&gt;/g;
    s/</&lt;/g;
    s/"/&quot;/g;
    s/'/&#39;/g;
    return $_;
}

1;
