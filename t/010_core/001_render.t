use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More;

do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [],
    );
    is $form->render, '';
};
do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [
            TextField(name => 'yay', label => 'foo')
        ],
    );
    is $form->render, '<label for="id_yay">foo</label><input id="id_yay" name="yay" type="text" />';
};
# textfield + label css
do {
    my $form = HTML::Shakan->new(
        request => query,
        fields => [
            TextField(name => 'yay', label => 'foo', label_class => 'control-label')
        ],
    );
    is $form->render, '<label class="control-label" for="id_yay">foo</label><input id="id_yay" name="yay" type="text" />';
};

done_testing;
