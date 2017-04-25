package HTML::Shakan::Widgets::Simple;
use strict;
use warnings;
use HTML::Escape;
use List::MoreUtils qw/zip/;

sub render {
    my ($self, $form, $field) = @_;

    my $type = $field->widget;
    my $code = $self->can("widget_${type}") or die "unknown widget type: $type";
    $code->(
        $self, $form, $field
    );
}

sub _attr {
    my $attr = shift;

    my @ret;

    for my $key (sort keys %$attr) {
        push @ret, sprintf(q{%s="%s"}, HTML::Escape::escape_html($key), HTML::Escape::escape_html($attr->{$key}));
    }
    join ' ', @ret;
}


sub widget_input {
    my ($self, $form, $field) = @_;

    my $value = $form->fillin_param($field->{name});
    if (defined $value) {
        $field->value($value);
    }

    return '<input ' . _attr($field->attr) . " />";
}

sub widget_textarea {
    my ($self, $form, $field) = @_;

    my $value = $form->fillin_param($field->{name}) || '';
    my $attr = {%{$field->attr}}; # shallow copy
    delete $attr->{type}; # textarea tag doesn't need this
    return '<textarea ' . _attr($attr) . ">" . HTML::Escape::escape_html($value) . "</textarea>";
}

sub widget_select {
    my ($self, $form, $field) = @_;

    my $choices = $field->{choices};

    my $value = $form->fillin_param($field->{name});

    my @t;
    push @t, sprintf(q{<select %s>}, _attr($field->attr));
    for (my $i=0; $i<@$choices; $i+=2) {
        my ($a, $b) = ($choices->[$i], $choices->[$i+1]);
        push @t, sprintf(
            q{<option value="%s"%s>%s</option>},
            HTML::Escape::escape_html($a),
            (defined $value && $value eq $a ? ' selected="selected"' : ''),
            HTML::Escape::escape_html($b));
    }
    push @t, q{</select>};
    return join "\n", @t;
}

sub widget_radio {
    my ($self, $form, $field) = @_;

    my $choices = $field->{choices};

    my $value = $form->fillin_param($field->{name});

    my $label_css = ($field->has_item_label_class() && $field->item_label_class ne '')
        ? sprintf(q{ class="%s"}, $field->item_label_class)
        : '';

    my @t;
    push @t, "<ul>";
    for (my $i=0; $i<@$choices; $i+=2) {
        my ($a, $b) = ($choices->[$i], $choices->[$i+1]);
        push @t, sprintf(
            q{<li><label%s><input %s type="radio" value="%s"%s />%s</label></li>},
            $label_css,
            _attr({
                %{ $field->attr },
                id => sprintf( $field->id_tmpl, $field->{name}, $i / 2 ),
            }),
            HTML::Escape::escape_html($a),
            (defined $value && $value eq $a ? ' checked="checked"' : ''),
            HTML::Escape::escape_html($b)
        );
    }
    push @t, "</ul>";
    join "\n", @t;
}

sub widget_checkbox {
    my ($self, $form, $field) = @_;

    my $choices = $field->{choices};

    my $values = $form->fillin_param($field->{name});
    unless (ref $values) {
        $values = defined $values ? [$values] : [];
    }
    my $label_css = ($field->has_item_label_class() && $field->item_label_class ne '')
        ? sprintf(q{ class="%s"}, $field->item_label_class)
        : '';

    my @t;
    push @t, "<ul>";
    for (my $i=0; $i<@$choices; $i+=2) {
        my ($val, $label) = ($choices->[$i], $choices->[$i+1]);
        my $checked = grep /^$val$/, @$values;

       push @t, sprintf(
            '<li><label%s><input %s type="checkbox" value="%s"%s />%s</label></li>',
            $label_css,
            _attr({
                %{ $field->attr },
                id => sprintf( $field->id_tmpl, $field->{name}, $i / 2 ),
            }),
            HTML::Escape::escape_html($val),
            ($checked ? ' checked="checked"' : ''),
            HTML::Escape::escape_html($label),
        );
    }
    push @t, "</ul>";
    join "\n", @t;
}

sub widget_date {
    my ($self, $form, $field) = @_;
    my $name = $field->{name} or die "missing name";
    my $years = $field->{years} or die "missing years";

    my $set = sub {
        my ($choices, $suffix) = @_;
        $self->widget_select(
            $form,
            HTML::Shakan::Field::Choice->new(
                name => "${name}_${suffix}",
                choices => [zip(@$choices, @$choices)],
            )
        );
    };

    my @t;

    push @t, '<span>';

    push @t, $set->($years, 'year');
    push @t, $set->([1..12], 'month');
    push @t, $set->([1..31], 'day');

    push @t, '</span>';

    join "\n", @t;
}

sub field_filter {
    my ($self, $form, $field, $params) = @_;

    if ($field->widget eq 'date') {
        my @c;
        for my $k (qw/year month day/) {
            my $key = $field->name . '_' . $k;
            my $v = $form->request->param($key);
            if (defined $v) {
                push @c, $v;
            }
        }

        if (@c == 3) {
            $params->{$field->name} = join '-', @c; # http-date style
        }
    }
}

1;
__END__

=head1 NAME

HTML::Shakan::Widgets::Simple - simple default HTML widgets

=head1 DESCRIPTION

This is basic default widgets class.

This module generates basic XHTML.

=head1 AUTHORS

Tokuhiro Matsuno

=head1 SEE ALSO

L<HTML::Shakan>

