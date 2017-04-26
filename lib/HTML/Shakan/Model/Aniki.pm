package HTML::Shakan::Model::Aniki;
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
    for my $column ($model->schema->get_table($name)->field_names) {
        next unless exists $params->{$column};
        $row->{$column} = $params->{$column};
    }
    $model->insert($name => $row);
}

sub update {
    my ($self, $row) = @_;
    my $dat = {};
    my $params = $self->form->params();
    my $columns = $row->get_columns;
    for my $column (keys %$columns) {
        next unless exists $params->{$column};
        $dat->{$column} = $params->{$column};
    }
    $row->handler->update($row, $dat)
        if scalar(keys(%$dat));
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Model::Aniki - Aniki bindings for Shakan

=head1 SYNOPSIS

    # in edit form
    my $form = HTML::Shakan->new(
        model => 'Aniki'
    );
    my $row = $db->select('any_table', {})->first;
    if ($form->submitted_and_valid) {
        $form->model->update( $row );
        redirect('/to/anywhere');
    } else {
        $form->model->fill( $row );
        render_template({form => $form, row => $row});
    }

    # add form
    my $form = HTML::Shakan->new(
        model => 'Aniki'
    );
    if ($form->submitted_and_valid) {
        $form->model->create( $db, 'user' );
        redirect('/to/anywhere');
    } else {
        $form->model->fill( $row );
        render_template({form => $form, row => $row});
    }

=head1 DESCRIPTION

wrapper class for Aniki & HTML::Shakan

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

L<Aniki>

