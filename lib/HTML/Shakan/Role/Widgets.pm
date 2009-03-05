package HTML::Shakan::Role::Widgets;
use Any::Moose '::Role';

requires 'render';

has 'form' => (
    is       => 'ro',
    isa      => 'HTML::Shakan',
    required => 1,
);

no Any::Moose '::Role';
