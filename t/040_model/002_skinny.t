
use HTML::Shakan;
use t::Util;
use Test::Requires {
    'DBIx::Skinny' => 0.0740,
    'DBD::SQLite'  => 1.31,
};
use Test::More;
use HTML::Shakan::Model::DBIxSkinny;

{
    package MyModel;
    use DBIx::Skinny;

    package MyModel::Row;
    use base qw/DBIx::Skinny::Row/;

    package MyModel::Row::User;
    use base qw/MyModel::Row/;

    package MyModel::Schema;
    use DBIx::Skinny::Schema;

    install_table user => schema {
        pk 'foo';
        columns qw/foo bar/;
    };
}

die $@ if $@;

my $dm = MyModel->new({dsn => 'dbi:SQLite:'});
$dm->dbh->do(q{
    create table user (
        foo varchar(255),
        bar varchar(255)
    );
});

subtest 'fill' => sub {
    my $user = $dm->insert('user' => {
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
        model => HTML::Shakan::Model::DBIxSkinny->new()
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
        model => HTML::Shakan::Model::DBIxSkinny->new()
    );
    is $form->is_valid, 1, 'is_valid';
    $form->model->create($dm => 'user');
    my $user = $dm->single(user => {foo => 'gay'});
    ok $user, 'insert';
    is $user->foo, 'gay';
    is $user->bar, undef;
};

subtest 'update' => sub {
    my $user = $dm->single(user => {foo => 'gay'});
    $user->update({bar => "origin"});
    ok $user, 'fetch user';
    my $form = HTML::Shakan->new(
        request => query({'foo'=> 'way', 'bar' => 'ATTACK!'}),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DBIxSkinny->new()
    );
    is $form->is_valid, 1, 'is-valid';
    $form->model->update($user);

    ok !$dm->single(user => {foo => 'gay'}), 'missing old row';
    ok $dm->single(user => {foo => 'way'});
    my $new = $dm->single(user => {foo => 'way'});
    is $new->bar, 'origin', 'do not modify filed without validation';
};

done_testing;

