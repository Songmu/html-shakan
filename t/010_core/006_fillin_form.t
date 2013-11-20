use strict;
use warnings;
use HTML::Shakan;
use t::Util;
use Test::More tests => 3;

do {
    my $form = HTML::Shakan->new(
        request => query({yay => 3}),
        fields => [
            TextField(name => 'yay')
        ],
    );
    is $form->render, '<label for="id_yay">yay</label><input id="id_yay" name="yay" type="text" value="3" />';
};

do {
    my $form = HTML::Shakan->new(
        request => query({yay => 'b'}),
        fields => [
            ChoiceField(name => 'yay', choices => [
                a => 1,
                b => 2,
            ])
        ],
    );
    is $form->render, trim(<<'...');
<label for="id_yay">yay</label><select id="id_yay" name="yay">
<option value="a">1</option>
<option value="b" selected="selected">2</option>
</select>
...
};

do {
    my $form = HTML::Shakan->new(
        request => query({yay => 'b'}),
        fields => [
            ChoiceField(
                widget => 'radio',
                name => 'yay',
                choices => [
                    a => 1,
                    b => 2,
                ]
            )
        ],
    );
    is $form->render, trim(<<'...');
<label for="id_yay">yay</label><ul>
<li><label><input id="id_yay_0" name="yay" type="radio" value="a" />1</label></li>
<li><label><input id="id_yay_1" name="yay" type="radio" value="b" checked="checked" />2</label></li>
</ul>
...
};

