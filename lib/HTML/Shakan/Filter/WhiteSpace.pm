package HTML::Shakan::Filter::WhiteSpace;
use Any::Moose;
with 'HTML::Shakan::Role::Filter';

sub filter {
    my $self = shift;

    local $_ = shift;
    s/^\s+//;
    s/\s+$//;
    $_;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
