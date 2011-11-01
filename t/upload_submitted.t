use strict;
use warnings;
use HTML::Shakan;
use Test::Requires 'Plack::Test', 'Hash::MultiValue';
use Test::More;
use Plack::Test;
use Plack::Request;
use HTTP::Request::Common;

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $form = HTML::Shakan->new(
        request => $req,
        fields => [
            FileField(name => 'file')
        ]
    );
    return [200, ['Content-Type' => 'text/plain'], [$form->submitted ? 'OK' : 'NG']];
};

test_psgi $app, sub {
    my $cb = shift;
    ok my $res = $cb->(POST '/', Content_type => 'form-data', Content => [
            file => ['t/dat/file_post.txt'],
        ]
    );
    is $res->content, 'OK';
};

done_testing;
