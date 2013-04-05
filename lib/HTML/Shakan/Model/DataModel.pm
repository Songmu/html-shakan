package HTML::Shakan::Model::DataModel;
use strict;
use warnings;
use Mouse;
with 'HTML::Shakan::Role::Model';

sub fill {
    my ($self, $row) = @_;
    my $columns = $row->get_columns;
    while (my ($k, $v) = each %$columns) {
        $self->form->fillin_params->{$k} = $v;
    }
}

sub create {
    my ($self, $model, $name) = @_;
    my $row = {};
    my $params = $self->form->params();
    for my $column ($model->get_schema($name)->column_names) {
        next unless exists $params->{$column};
        $row->{$column} = $params->{$column};
    }
    $model->set($name => $row);
}

sub update {
    my ($self, $row) = @_;
    my $dat = {};
    my $params = $self->form->params();
    my $columns = $row->get_columns;
    for my $column (keys %$columns) {
        next unless exists $params->{$column};
        $row->$column($params->{$column});
    }
    $row->update();
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Model::DataModel - Data::Model bindings for Shakan

=head1 SYNOPSIS

    # in edit form
    my $form = HTML::Shakan->new(
        model => 'DataModel'
    );
    my $row = $dm->lookup('any_table', 1);
    if ($form->submitted_and_valid) {
        $form->model->update( $row );
        redirect('/to/anywhere');
    } else {
        $form->model->fill( $row );
        render_template({form => $form, row => $row});
    }

    # add form
    my $form = HTML::Shakan->new(
        model => 'DataModel'
    );
    if ($form->submitted_and_valid) {
        $form->model->create( $model, 'user' );
        redirect('/to/anywhere');
    } else {
        $form->model->fill( $row );
        render_template({form => $form, row => $row});
    }

=head1 DESCRIPTION

wrapper class for Data::Model & HTML::Shakan

=head1 METHODS

=over 4

=item $form->model->fill($row)

fill this row to form

=item $form->model->create($model => $name);

insert new row.

=item $form->model->update($row);

update this row

=back

=head1 SEE ALSO

L<Data::Model>

