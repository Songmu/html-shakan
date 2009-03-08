use strict;
use warnings;
use HTML::Shakan;
use HTML::FormFu;
use CGI;
use Benchmark ':all';

my $q = CGI->new;
my $renderer = HTML::Shakan::Renderer::HTML->new();
my $fields = [ TextField( name => 'foo' ) ];

cmpthese(
    10000 => {
        cached_shakan => sub {
            my $form = HTML::Shakan->new(
                request => $q,
                fields => $fields,
                rendeerer => $renderer,
            );
            '<form method="post">'.$form->render.'</form>';
        },
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

