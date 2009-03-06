package HTML::Shakan::Filter::Hiragana;
use Any::Moose;
with 'HTML::Shakan::Role::Filter';
use Lingua::JA::Regular::Unicode qw(
    katakana2hiragana
);

sub filter {
    my ($self, $val) = @_;
    katakana2hiragana($val);
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
