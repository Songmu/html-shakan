use t::Util;
use Test::More;
use HTML::Shakan;
use CGI;

plan skip_all => 'this test requires Data::Mode' unless eval 'use Data::Model; 1;';
plan tests => 7;
require HTML::Shakan::Model::DataModel;

{
    package MyModel;
    use base 'Data::Model';
    use Data::Model::Schema;
    use Data::Model::Driver::Memory;

    my $driver = Data::Model::Driver::Memory->new();
    __PACKAGE__->set_base_driver($driver);
    install_model user => schema {
        key 'foo';
        column 'foo' => {
            auto_increment => 1 ,
            type => 'varchar',
        };
    };
}

my $dm = MyModel->new();
# fill
{
    my $user = $dm->set('user' => {
        foo => 'bar'
    });
    my $form = HTML::Shakan->new(
        request => CGI->new(),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DataModel->new()
    );
    $form->model->fill($user);
    is $form->render, trim(<<'...');
<input id="id_foo" name="foo" type="text" value="bar" />
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
        model => HTML::Shakan::Model::DataModel->new()
    );
    is $form->is_valid, 1;
    $form->model->create($dm => 'user');
    my $user = $dm->get(user => 'gay');
    ok $user;
}

# update
{
    my $user = $dm->lookup(user => 'gay');
    ok $user;
    my $form = HTML::Shakan->new(
        request => CGI->new({'foo'=> 'way'}),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DataModel->new()
    );
    is $form->is_valid, 1;
    $form->model->update($user);

    ok !$dm->get(user => 'gay');
    ok $dm->get(user => 'way');
}
