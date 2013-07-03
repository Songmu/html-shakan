package HTML::Shakan::Widgets::jQueryUI;
use strict;
use warnings;
use parent 'HTML::Shakan::Widgets::Simple';

BEGIN {
die 'this module is under construction';
};

sub head_tag {
    <<'...';
<script src="http://www.google.com/jsapi"></script>
<script>
google.load("jquery", "1.3.2");
google.load("jqueryui", "1.7.0");
</script>
...
}

sub widget_date {
    my ($self, $field) = @_;

    my $id = $field->id;

    my @t = shift;
    push @t, $self->widget_input(
        $field
    );
    push @t, <<"...";
<script>
    jQuery(function(\$){
        \$("#$id").datepicker();   
    });   
</script>
...
    join "\n", @t;
}

sub field_filter {
    # nop
}

1;
__END__

=for stopwords jQueryUI datepicker

=head1 NAME

HTML::Shakan::Widgets::jQueryUI - jQueryUI

=head1 DESCRIPTION

This is a widgets library using jQueryUI.

Currently, this library enhancements the datepicker only :)

=head1 AUTHOR

Tokuhiro Matsuno

=head1 SEE ALSO

L<http://jqueryui.com/>

