package HTML::Shakan::Model::DBIxSkinny;
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
    for my $column (@{ $model->schema->schema_info->{$name}->{columns} }) {
        next unless exists $params->{$column};
        $row->{$column} = $params->{$column};
    }
    $model->insert($name => $row);
}

sub insert { shift->create(@_) }

sub update {
    my ($self, $row) = @_;
    my $dat = {};
    my $columns = $row->get_columns;
    my $params = $self->form->params();
    for my $column (keys %$columns) {
        next unless exists $params->{$column};
        $dat->{$column} = $params->{$column};
    }
    $row->update($dat);
}

no Mouse;
__PACKAGE__->meta->make_immutable;
__END__

=head1 NAME

HTML::Shakan::Model::DBIxSkinny - DBIx::Skinny binding for HTML::Shakan

=head1 SYNOPSIS

    # create form object
    my $form = HTML::Shakan->new(
        request => CGI->new(),
        fields => [
            TextField(
                name => 'foo',
            ),
        ],
        model => HTML::Shakan::Model::DBIxSkinny->new()
    );

    # fillin_form
    $form->model->fill($row);

    # insert
    $form->model->create($skinny => $table);

    # update
    $form->model->update($row);

=head1 DESCRIPTION

This is L<DBIx::Skinny> binding for L<HTML::Shakan>.You can easy to
insert/fill/update by L<HTML::Shakan>.

=head1 METHODS

=over 4

=item $form->model->fill($row);

fill the $row data to form.$row is instance of row class of DBIx::Skinny.

=item my $row = $form->model->create($skinny, $table);

insert form data to $table.

=item my $row = $form->model->insert($skinny, $table);

insert method is synonym of create method.

=item $form->model->update($row);

update $row by form data.

=back

=head1 SEE ALSO

L<DBIx::Skinny>, L<HTML::Shakan>

=cut

