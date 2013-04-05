package HTML::Shakan::Filter::KatakanaZ;
use strict;
use warnings;
use Mouse;
with 'HTML::Shakan::Role::Filter';
use Lingua::JA::Regular::Unicode qw(
    hiragana2katakana
    katakana_h2z
);

sub filter {
    my ($self, $val) = @_;
    hiragana2katakana(katakana_h2z($val));
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Filter::KatakanaZ - convert Hiragana to Katakana

=head1 SYNOPSIS

    TextField(name => 'body', filters => [qw/Katakana/])

=head1 DESCRIPTION

This module converts Hiragana chars to Katakana chars.
(for Japanese)

=head1 SEE ALSO

L<Lingua::JA::Regular::Unicode>

