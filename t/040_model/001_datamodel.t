
use Test::More;
use HTML::Shakan;
use t::Util;
use Test::Requires 'Data::Model';

require HTML::Shakan::Model::DataModel;

# evaluate at run time
eval <<'...';
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
        column 'bar' => {
            auto_increment => 1 ,
            type => 'varchar',
        };
    };
...
die $@ if $@;

my $dm = MyModel->new();

subtest 'fill' => sub {
    my $user = $dm->set('user' => {
        foo => 'bar'
    });
    my $form = HTML::Shakan->new(
        request => query(),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DataModel->new()
    );
    $form->model->fill($user);
    is $form->render, trim(<<'...');
<label for="id_foo">foo</label><input id="id_foo" name="foo" type="text" value="bar" />
...
};

subtest 'create' => sub {
    my $form = HTML::Shakan->new(
        request => query({'foo'=> 'gay', bar => 'ATTACK'}),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DataModel->new()
    );
    is $form->is_valid, 1;
    $form->model->create($dm => 'user');
    my ($user) = $dm->get(user => 'gay');
    ok $user;
    is $user->foo, 'gay';
    is $user->bar, undef;
};

subtest 'update' => sub {
    my $user = $dm->lookup(user => 'gay');
    ok $user;
    my $form = HTML::Shakan->new(
        request => query({'foo'=> 'way', bar => 'ATTACK'}),
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
    {
        my ($u) = $dm->get(user => 'way');
        is $u->bar, undef;
    }
};

done_testing;

