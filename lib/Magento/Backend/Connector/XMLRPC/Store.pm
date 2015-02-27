package Magento::Backend::Connector::XMLRPC::Store;

use Magento::Backend::Class::Store;
use Magento::Backend::Resource::Store;

use Moose;
use Moose::Util qw( apply_all_roles );

sub info {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    #retrieve hash of info
    my $response = $connector->_client_call(
        'store.info',
        [
            ($params{storeID}),
        ],
    );
    
    # cleanup the rubbish
    
    return $response;
}

sub listStores {
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    # retrieve list as an array of hashes
    my $response = $connector->_client_call(
        'store.list',
    );
    
    # create list of Stores
    my $resource = Magento::Backend::Resource::Store->new(
        _connector => $connector,
    );
    my @list;
    foreach my $item (@$response) {
        # create base class
        my $new_object = Magento::Backend::Class::Store->new(
             store_id => $item->{store_id},
             _resource => $resource,
        );
        
        # apply role and assign attributes
        apply_all_roles ($new_object,
            'Magento::Backend::Connector::XMLRPC::_Role::Store::Entity');
        foreach my $key (keys %$item) {
            $new_object->{$key} = $item->{$key};
        }
        
        push @list, $new_object;
    }
    
    return \@list;
};

package Magento::Backend::Connector::XMLRPC::_Role::Store::Entity;
use Moose::Role;
has code => ( # Store view code
    is => 'ro',
);
has website_id => ( # Website ID
    is  => 'ro',
    isa => 'Int',
);
has group_id => ( # Group ID
    is  => 'ro',
    isa => 'Int',
);
has name => ( # Store name
    is => 'ro',
);
has sort_order => ( # Store view sort order
    is  => 'ro',
    isa => 'Int',
);
has is_active => ( # Defines whether the store is active
    is  => 'ro',
    isa => 'Int',
);

1;
