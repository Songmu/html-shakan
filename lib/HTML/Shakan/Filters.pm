package HTML::Shakan::Filters;
use strict;
use warnings;
use Scalar::Util 'blessed';

sub _get_filter {
    my $pkg = shift;
    $pkg = $pkg =~ s/^\+// ? $pkg : "HTML::Shakan::Filter::$pkg";
    Any::Moose::load_class($pkg);
    return $pkg->new();
}

sub filter {
    my ($class, $filter_ary, $val) = @_;
    $filter_ary = [$filter_ary] unless ref $filter_ary;
    for my $filter (@$filter_ary) {
        unless (blessed $filter) {
            $filter = _get_filter($filter);
        }
        $val = $filter->filter($val);
    }
    $val;
}

1;
