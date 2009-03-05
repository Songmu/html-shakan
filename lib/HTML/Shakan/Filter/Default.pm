package HTML::Shakan::Filter::Default;
use strict;
use warnings;

sub init {
    +{
        'WhiteSpace' => sub {
            s/^\s+//;
            s/\s+$//;
        },
    };
}

1;
