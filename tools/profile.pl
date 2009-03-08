use strict;
use warnings;
use HTML::Shakan;
use CGI;

my $q = CGI->new;

for (0..1000) {
    my $form = HTML::Shakan->new(
        request => $q,
        fields => [
            TextField(name => 'foo')
        ],
    );
    '<form method="post">'.$form->render.'</form>';
}

