use strict;
use warnings;
use HTML::Shakan;
use HTML::FormFu;
use CGI;
use Benchmark ':all';

my $q = CGI->new;

cmpthese(
    10000 => {
        shakan => sub {
            my $form = HTML::Shakan->new(
                request => $q,
                fields => [
                    TextField(name => 'foo')
                ],
            );
            '<form method="post">'.$form->render.'</form>';
        },
        formfu => sub {
            my $form = HTML::FormFu->new({
                elements => [
                    {type => 'Text', name => 'foo'}
                ],
            });
            $form->render;
        },
    },
);

