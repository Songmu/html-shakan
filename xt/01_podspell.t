use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');
__DATA__
Tokuhiro Matsuno
tokuhirom  slkjfd gmail.com
HTML::Shakan
DSL
FormGeneration
FormGenerator
TT
YAML
csrf
imager
API
ToscaWidgets
edokko
html
shakan
sakan
attr
DateTime
jQueryUI
datepicker
google
newforms
Django
Katakana
Hiragana
XHTML
url
pw
birthdate
UINT
FileField
foo
