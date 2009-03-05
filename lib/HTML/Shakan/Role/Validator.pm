package HTML::Shakan::Role::Validator;
use Any::Moose '::Role';

has 'form' => (
    is       => 'ro',
    weak_ref => 1,
    required => 1,
);

1;
