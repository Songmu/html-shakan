{
    package My::Form;
    use HTML::Shakan::Declare;
    form 'my_form' => (
        ChoiceField(
            name    => 'foo',
            widget  => 'select',
            choices => [qw/1 one 2 two 3 three/],
        ),
        ChoiceField(
            name    => 'bar',
            widget  => 'radio',
            choices => [qw/1 one 2 two 3 three/],
        ),
    );
}

{
    package main;
    use strict;
    use warnings;
    use Test::More;
    use t::Util;

    my $first = form('my_form')->render();
    my $second = form('my_form')->render();
    is($first, $second, "first time and second time should return same result");

    sub form {
        my $name = shift;
        return My::Form->get(
            $name => (
                request => query(),
            ),
        );
    }
    done_testing;
}

