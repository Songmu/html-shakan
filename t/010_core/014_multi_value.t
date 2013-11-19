use strict;
use warnings;
use utf8;
use Test::More;

use CGI;
use HTML::Shakan;

my $form = HTML::Shakan->new(
    request => CGI->new({
        p => [qw/bar baz/],
    }),
    fields => [ChoiceField(
        name => 'p',
        choices => [
            tokyo => 'tokyo',
            kyoto => 'kyoto',
        ],
    )],
);

my $p = $form->param('p');
is $p, 'baz';
my @p = $form->param('p');
is_deeply \@p, [qw/bar baz/];

$form->param(p => [qw/tokyo kyoto/]);
is scalar($form->param('p')), 'kyoto';
is_deeply [$form->param('p')], [qw/tokyo kyoto/];

done_testing;
