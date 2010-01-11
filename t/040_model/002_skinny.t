use t::Util;
use HTML::Shakan;
use CGI;
use Test::Requires 'DBIx::Skinny', 'DBD::SQLite';
use Test::More tests => 7;
use HTML::Shakan::Model::DBIxSkinny;

{
    package MyModel;
    use DBIx::Skinny;

    package MyModel::Schema;
    use DBIx::Skinny::Schema;

    install_table user => schema {
        pk 'foo';
        columns qw/foo/;
    };
}

die $@ if $@;

my $dm = MyModel->new({dsn => 'dbi:SQLite:'});
$dm->dbh->do(q{
    create table user (
        foo varchar(255)
    );
});
# fill
{
    my $user = $dm->insert('user' => {
        foo => 'bar'
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
}

# create
{
    my $form = HTML::Shakan->new(
        request => CGI->new({'foo'=> 'gay'}),
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
}

# update
{
    my $user = $dm->single(user => {foo => 'gay'});
    ok $user, 'fetch user';
    my $form = HTML::Shakan->new(
        request => CGI->new({'foo'=> 'way'}),
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
}
