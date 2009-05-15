use t::Util;
use Test::More;

plan skip_all => 'this test requires DT' unless eval 'use DateTime;1;';
plan skip_all => 'this test requires DT::Format::HTTP' unless eval 'use DateTime::Format::HTTP;1;';
plan tests => 4;

require HTML::Shakan::Inflator::DateTime;

{
    my $dt = HTML::Shakan::Inflator::DateTime->new->inflate(
        '2009-03-03',
    );
    isa_ok $dt, 'DateTime';
    is $dt->ymd, '2009-03-03';
    is $dt->time_zone->name, 'floating', 'default time zone is "floating"';
}

{
    my $dt = HTML::Shakan::Inflator::DateTime->new(
        time_zone => 'Asia/Tokyo'
    )->inflate(
        '2009-03-03',
    );
    is $dt->time_zone->name, 'Asia/Tokyo', 'use my own tz';
}
