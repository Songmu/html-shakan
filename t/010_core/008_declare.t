use strict;
use warnings;

use Test::More;
use t::Util;

{
    package My::Form;
    use HTML::Shakan::Declare;

    form 'add' => (
        TextField(
            name => 'name',
            required => 1,
        ),
        TextField(
            name => 'email',
            required => 1,
        ),
    );
}

my $form = My::Form->get(
    'add' => (
        request => query,
    )
);
isa_ok $form, 'HTML::Shakan';
is $form->render, trim(<<'...');
<label for="id_name">name</label><input id="id_name" name="name" type="text" /><label for="id_email">email</label><input id="id_email" name="email" type="text" />
...

done_testing;
