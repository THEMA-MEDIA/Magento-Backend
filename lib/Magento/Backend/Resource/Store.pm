package Magento::Backend::Resource::Store;

use Moose;

with 'Magento::Backend::Resource';

sub info {
    my $self = shift;
    my $result = $self->_connector->info(@_);
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

sub listStores {
    my $self = shift;
    my $result = $self->_connector->listStores(@_);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

1;
