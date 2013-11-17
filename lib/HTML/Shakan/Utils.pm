package HTML::Shakan::Utils;
use strict;
use warnings;
use parent qw/Exporter/;

our @EXPORT = qw/encode_entities/;

use HTML::Escape ();

# backward compatible
sub encode_entities {
    warn "HTML::Shakan::Utils::encode_entities() is deprecated. use HTML::Escape::escape_html() instead.\n";
    HTML::Escape::escape_html(@_);
}

1;
