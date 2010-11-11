use t::Util;
use HTML::Shakan;
use CGI;
use Test::Requires 'DBIx::Skinny', 'DBD::SQLite';
use Test::More;
use HTML::Shakan::Model::DBIxSkinny;

{
    package MyModel;
    use DBIx::Skinny;

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
        request => CGI->new(),
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
        request => CGI->new({'foo'=> 'gay', 'bar' => 'ATTACK!'}),
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
        request => CGI->new({'foo'=> 'way', 'bar' => 'ATTACK!'}),
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

