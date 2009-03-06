package HTML::Shakan::Filter::KatakanaZ;
use Any::Moose;
with 'HTML::Shakan::Role::Filter';
use Lingua::JA::Regular::Unicode qw(
    hiragana2katakana
    katakana_h2z
);

sub filter {
    my ($self, $val) = @_;
    hiragana2katakana(katakana_h2z($val));
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
