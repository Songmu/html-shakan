package t::Util;
use strict;
use warnings;
use base 'Exporter';
use CGI;

BEGIN {
    # XXX suppress CGI list context warnings.
    # This is only workaround. We should remove CGI.pm dependency from testing and switch Plack::Request or so.
    my $orig = CGI->can('param');
    no warnings 'redefine';
    no strict 'refs';
    *CGI::param = sub {
        use strict 'refs';
        local $CGI::LIST_CONTEXT_WARN = 0;
        $orig->(@_);
    };
}

our @EXPORT = qw(query trim);

sub query { CGI->new(@_) }

sub trim {
    local $_ = shift;
    s/\n$//;
    $_;
}

1;
