
use HTML::Shakan;
use t::Util;
use Test::Requires {
    'Aniki' => 1.00,
    'DBD::SQLite'  => 1.31,
};
use Test::More;
use HTML::Shakan::Model::Aniki;

{
    package MyModel::Schema;
    use DBIx::Schema::DSL;
    database 'SQLite';
    create_table 'user' => columns {
        varchar 'foo', length => 255, 'primary_key' => 1;
        varchar 'bar', length => 255;
    };

    package MyModel;
    use Mouse;
    extends qw/Aniki/;

    MyModel->setup(
        schema => 'MyModel::Schema',
    );

}

die $@ if $@;

my $dm = MyModel->new(
        connect_info  => ['dbi:SQLite:'],
        on_connect_do => "CREATE TABLE user (foo VARCHAR(255), bar VARCHAR(255));",
    );

subtest 'fill' => sub {
    my $user = $dm->insert_and_fetch_row('user' => {
        foo => 'bar',
        bar => 'baz',
    });
    my $form = HTML::Shakan->new(
        request => query(),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::Aniki->new()
    );
    $form->model->fill($user);
    is $form->render, trim(<<'...'), 'fill';
<label for="id_foo">foo</label><input id="id_foo" name="foo" type="text" value="bar" />
...
};

subtest 'create' => sub {
    my $form = HTML::Shakan->new(
        request => query({'foo'=> 'gay', 'bar' => 'ATTACK!'}),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::Aniki->new()
    );
    is $form->is_valid, 1, 'is_valid';
    $form->model->create($dm => 'user');
    my $user = $dm->select(user => {foo => 'gay'})->first;
    ok $user, 'insert';
    is $user->foo, 'gay';
    is $user->bar, undef;
};

subtest 'update' => sub {
    my $user = $dm->select(user => {foo => 'gay'})->first;
    $dm->update($user => {bar => "origin"});
    ok $user, 'fetch user';
    my $form = HTML::Shakan->new(
        request => query({'foo'=> 'way', 'bar' => 'ATTACK!'}),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::Aniki->new()
    );
    is $form->is_valid, 1, 'is-valid';
    $form->model->update($user);
    ok !$dm->select(user => {foo => 'gay'})->first, 'missing old row';
    ok $dm->select(user => {foo => 'way'})->first;
    my $new = $dm->select(user => {foo => 'way'})->first;
    is $new->bar, 'origin', 'do not modify field without validation';
};

done_testing;

