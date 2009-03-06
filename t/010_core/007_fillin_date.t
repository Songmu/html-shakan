use t::Util;
use Test::More tests => 1;
use HTML::Shakan;

my $form = HTML::Shakan->new(
    request => query({yay_year => 2002, yay_month => 1, yay_day => 19}),
    fields => [
        DateField(name => 'yay', years => [2000..2003])
    ],
);

is $form->render(), trim(<<'...');
<span>
<select name="yay_year">
<option value="2000">2000</option>
<option value="2001">2001</option>
<option value="2002" selected="selected">2002</option>
<option value="2003">2003</option>
</select>
<select name="yay_month">
<option value="1" selected="selected">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
</select>
<select name="yay_day">
<option value="1">1</option>
<option value="2">2</option>
<option value="3">3</option>
<option value="4">4</option>
<option value="5">5</option>
<option value="6">6</option>
<option value="7">7</option>
<option value="8">8</option>
<option value="9">9</option>
<option value="10">10</option>
<option value="11">11</option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19" selected="selected">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30</option>
<option value="31">31</option>
</select>
</span>
...

