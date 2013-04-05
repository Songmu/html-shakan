package HTML::Shakan::Filter::Hiragana;
use strict;
use warnings;
use Mouse;
with 'HTML::Shakan::Role::Filter';
use Lingua::JA::Regular::Unicode qw(
    katakana2hiragana
);

sub filter {
    my ($self, $val) = @_;
    katakana2hiragana($val);
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Filter::Hiragana - convert Katakana to Hiragana

=head1 SYNOPSIS

    TextField(name => 'body', filters => [qw/Hiragana/])

=head1 DESCRIPTION

This module converts Katakana chars to Hiragana chars.
(for Japanese)

=head1 SEE ALSO

L<Lingua::JA::Regular::Unicode>

