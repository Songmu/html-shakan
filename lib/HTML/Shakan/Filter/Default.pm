package HTML::Shakan::Filter::Default;
use strict;
use warnings;

sub filters {
    {
        'WhiteSpace' => sub {
            s/^\s+//;
            s/\s+$//;
        },
    };
}

1;
