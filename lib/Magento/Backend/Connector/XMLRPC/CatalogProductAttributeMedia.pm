package Magento::Backend::Connector::XMLRPC::CatalogProductAttributeMedia;

use Magento::Backend::Class::CatalogProductAttributeMedia;
use Magento::Backend::Resource::CatalogProductAttributeMedia;

use Moose;
use Moose::Util qw( apply_all_roles );

use DDP;

sub create {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;

    if (exists $params{productSKU}) {
        $params{identifier} = $params{productSKU};
        $params{identifier_type} = 'sku';
    }
    else {
        $params{identifier} = $params{productID};
        $params{identifier_type} = undef;
    }
    
    my $response = $connector->_client_call(
        'catalog_product_attribute_media.create',
        [
            $params{productSKU},
            $params{mediaData},
            $params{storeView},
            $params{identifier_type},
        ],
    );
#       if ($response) {
#           my $resource = Magento::Backend::Resource::CatalogProduct->new(
#               _connector => $connector,
#           );
#           my $new_object = Magento::Backend::Class::CatalogProduct->new(
#                product_id => $response,
#                _resource => $resource,
#           );
#           # apply role and assign attributes
#   #
#   # we might do something smart to fill in some attributes we used to create it
#   #
#   #         apply_all_roles ($new_object,
#   #             'Magento::Backend::Connector::XMLRPC::_Role::CatalogProductAttributeMedia::Entity');
#   #         foreach my $key (keys %$item) {
#   #             $new_object->{$key} = $item->{$key};
#   #         }
#           return $new_object;
#       }
p $response;
    return $response;
}; # create

sub info {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    # when querying based on productSKU
    # the last argument needs to be litteral 'sku'
    if (exists $params{productSKU}) {
        $params{identifier} = $params{productSKU};
        $params{identifier_type} = 'sku';
    }
    else {
        $params{identifier} = $params{productID};
        $params{identifier_type} = undef;
    }
    
#   !exists $params{attributes} && return; # debatable
    
    # make the attribute list into a hash
    # don't ask why, but the keys can be arbitrary
#   my $requested = undef;
#   if ($params{attributes}) {
#       for (0..$#{$params{attributes}}) {
#           $requested->{$params{attributes}[$_]} = $params{attributes}[$_];
#       };
#       $params{requested} = $requested;
#   };
    
    #retrieve hash of info
    my $response = $connector->_client_call(
        'catalog_product_attribute_media.info',
        [
            $params{identifier},
            $params{file},
            $params{storeView},
            $params{identifier_type},
        ],
    );
    
    # cleanup the rubbish
    
    # fix stupid returns like:
    # categories are actually a list of id's
    # websites are actually a list of id's
    # TODO make categories into a list of Category objects
    $response->{category_ids} = delete $response->{categories}
        if exists $response->{categories};
    $response->{website_ids}  = delete $response->{websites}
        if exists $response->{websites};
    $response->{set_id}       = delete $response->{set}
        if exists $response->{set};
    
    # remove unrequested attributes
#   if ($params{attributes}) {
#       for (keys %$response) {
#           if (! exists $requested->{$_} ) {
#               delete $response->{$_};
#           };
#       };
#   };
p $response;
    return $response;
}; # info

sub listImages {
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    # when querying based on productSKU
    # the last argument needs to be litteral 'sku'
    if (exists $params{productSKU}) {
        $params{identifier} = $params{productSKU};
        $params{identifier_type} = 'sku';
    }
    else {
        $params{identifier} = $params{productID};
        $params{identifier_type} = undef;
    }
    
    my $response = $connector->_client_call(
        'catalog_product_attribute_media.list',
        [
            $params{identifier},
            $params{storeView},
#           $params{requested},
            $params{identifier_type},
        ],
    );
p $response;
    return $response;
    
#   # create list of Stores
#   my $resource = Magento::Backend::Resource::CatalogProduct->new(
#       _connector => $connector,
#   );
#   my @list;
#   foreach my $item (@$response) {
#       # create base class
#       my $new_object = Magento::Backend::Class::CatalogProduct->new(
#            product_id => $item->{product_id},
#            _resource => $resource,
#       );
#       
#       # apply role and assign attributes
#       apply_all_roles ($new_object,
#           'Magento::Backend::Connector::XMLRPC::_Role::CatalogProduct::Entity');
#       $item->{set_id} = delete $item->{set}; # it is clearly an ID
#       foreach my $key (keys %$item) {
#           $new_object->{$key} = $item->{$key};
#       }
#       
#       push @list, $new_object;
#   }
#   
#   return \@list;
}; # listProducts

sub update {
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
        
    # do some final checkup before making the call
    
    # when querying based on productSKU
    # the last argument needs to be litteral 'sku'
    if (exists $params{productSKU}) {
        $params{identifier} = $params{productSKU};
        $params{identifier_type} = 'sku';
    }
    else {
        $params{identifier} = $params{productID};
        $params{identifier_type} = undef;
    }

    my $response = $connector->_client_call(
        'catalog_product_attribute_media.update',
        [
            $params{identifier},
            $params{file},
            $params{mediaData},
            $params{storeView},
            $params{identifier_type},
        ],
    );
p $response;
    return $response;
} # update



package Magento::Backend::Connector::XMLRPC::_Role::CatalogProductAttributeMedia::Entity;
use Moose::Role;
has sku => ( # Product SKU
    is  => 'ro',
);
has name => ( # Product name
    is  => 'ro',
);
has set_id => ( # Product attribute set !!!
    is  => 'ro',
);
has type => ( # Type of the product
    is  => 'ro',
);
has category_ids => ( # Array of category IDs
    is  => 'ro',
    isa => 'ArrayRef[Int]',
);
has website_ids => ( # Array of website IDs
    is  => 'ro',
    isa => 'ArrayRef[Int]',
);

1;
