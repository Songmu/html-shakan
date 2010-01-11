package HTML::Shakan::Model::DBIxSkinny;
use Any::Moose;
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
    for my $column (@{ $model->schema->schema_info->{$name}->{columns} }) {
        $row->{$column} = $self->form->param($column);
    }
    $model->insert($name => $row);
}

sub update {
    my ($self, $row) = @_;
    my $dat = {};
    my $columns = $row->get_columns;
    for my $column (keys %$columns) {
        $dat->{$column} = $self->form->param($column);
    }
    $row->update($dat);
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
__END__
