package Magento::Backend::Class::Store;

use Moose;

with 'Magento::Backend::Class';

has store_id => ( # Store view ID
    is  => 'ro',
    isa => 'Int',
    required => 1,
);

sub info {
    my $self = shift;
    my %params = @_;
    $params{storeID} = $self->{store_id};
    my $result = $self->_resource->info(
         %params,
    );
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

1;
