package HTML::Shakan::Filters;
use strict;
use warnings;

my $filters = {};

__PACKAGE__->install_filters('Default');

sub install_filters {
    my ($class, $pkg) = @_;
    $pkg = $pkg =~ s/^\+// ? $pkg : "HTML::Shakan::Filter::$pkg";
    Any::Moose::load_class($pkg);
    $filters = +{ %$filters, %{$pkg->filters()} };
}

sub filter {
    my ($class, $filter_ary, $val) = @_;
    $filter_ary = [$filter_ary] unless ref $filter_ary;
    local $_ = $val;
    for my $filter (@$filter_ary) {
        $filters->{$filter}->();
    }
    $_;
}

1;
