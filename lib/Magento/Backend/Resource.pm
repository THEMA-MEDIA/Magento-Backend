package Magento::Backend::Resource;

use Moose::Role;

has _connector => (
    is  => 'ro',
#    does => 'Magento::Backend::Connector',
    required => 1,
);

1;

__END__
