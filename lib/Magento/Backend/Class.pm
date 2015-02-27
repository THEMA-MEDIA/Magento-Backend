package Magento::Backend::Class;

use Moose::Role;

has _resource => (
    is  => 'ro',
    does => 'Magento::Backend::Resource',
    required => 1,
);

1;
__END__
