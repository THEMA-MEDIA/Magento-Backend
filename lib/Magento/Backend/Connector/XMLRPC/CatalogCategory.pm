package Magento::Backend::Connector::XMLRPC::CatalogCategory;

use Magento::Backend::Class::CatalogCategory;
use Magento::Backend::Resource::CatalogCategory;
use Magento::Backend::Class::CatalogProduct;
use Magento::Backend::Resource::CatalogProduct;

use Moose;
use Moose::Util qw( apply_all_roles );

sub assignedProducts {
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    # retrieve list as an array of hashes
    my $response = $connector->_client_call(
        'catalog_category.assignedProducts',
        [
            $params{categoryID},
        ],
    );
    
    # create list 
    my $resource = Magento::Backend::Resource::CatalogProduct->new(
        _connector => $connector,
    );
    my @list;
    foreach my $item (@$response) {
        # create base class
        my $new_object = Magento::Backend::Class::CatalogProduct->new(
             product_id => $item->{product_id},
             _resource => $resource,
        );
        
        # apply role and assign attributes
        apply_all_roles ($new_object,
            'Magento::Backend::Connector::XMLRPC::_Role::CatalogCategory::AssignedProduct');
        $item->{set_id} = delete $item->{set}; # it is clearly an ID
        foreach my $key (keys %$item) {
            $new_object->{$key} = $item->{$key};
        }
        
        push @list, $new_object;
    }
    
    return \@list;
}; # assignedProducts

sub assignProduct {
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
        
    # make the call
    my $response = $connector->_client_call(
        'catalog_category.assignProduct',
        [
            $params{categoryID},
            $params{identifier},
            $params{position},
            $params{identifier_type},
        ],
    );
    
    return $response;
} # assignProduct

sub createCategory {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;
    
    if (! exists $params{parentID}) {
        $params{parentID} = $params{attributeData}{parent_id};
    }
    delete $params{attributeData}{parent_id};
    
    my $response = $connector->_client_call(
        'catalog_category.create',
        [
            $params{parentID},
            $params{attributeData},
            $params{storeView},
        ],
    );
    
    if ($response) {
        my $resource = Magento::Backend::Resource::CatalogCategory->new(
            _connector => $connector,
        );
        my $new_object = Magento::Backend::Class::CatalogCategory->new(
             category_id => $response,
             _resource => $resource,
        );
        # apply role and assign attributes
#
# we might do something smart to fill in some attributes we used to create it
#
#         apply_all_roles ($new_object,
#             'Magento::Backend::Connector::XMLRPC::_Role::CatalogProduct::Entity');
#         foreach my $key (keys %$item) {
#             $new_object->{$key} = $item->{$key};
#         }
        return $new_object;
        }
    
    return $response;
}; # create

sub deleteBranch {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    # make the call
    my $response = $connector->_client_call(
        'catalog_category.delete',
        [
            $params{categoryID},
        ],
    );
    
    # cleanup the rubbish
    
    return $response;
}; # deleteBranch

sub info {
    my $self = shift;
    my $connector = shift; # AUTOLOAD
    my %params = @_;
    
    # do some final checkup before making the call
    
    !exists $params{attributes} && return; # debatable
    
    # make the attribute list into a hash
    # don't ask why, but the keys can be arbitrary
    my $requested = undef;
    if ($params{attributes}) {
        for (0..$#{$params{attributes}}) {
            $requested->{$params{attributes}[$_]} = $params{attributes}[$_];
        };
        $params{requested} = $requested;
    };
    
    #retrieve hash of info
    my $response = $connector->_client_call(
        'catalog_category.info',
        [
            $params{categoryID},
            $params{storeView},
            $params{requested},
        ],
    );
    
    # cleanup the rubbish
    
    $response->{child_ids} = delete $response->{children}
        if exists $response->{children};
    $response->{all_child_ids}  = delete $response->{all_children}
        if exists $response->{all_children};
    
    # remove unrequested attributes
    if ($params{attributes}) {
        for (keys %$response) {
            if (! exists $requested->{$_} ) {
                delete $response->{$_};
            };
        };
    };
    
    return $response;
}; # info

sub levelCategories{
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
        
    # do some final checkup before making the call
    if (exists $params{website}) {
        delete $params{categoryID};
    }
    else {
        $params{website} = 0;
    }
    
    my $response = $connector->_client_call(
        'catalog_category.level',
        [
            $params{website},
            $params{storeView},
            $params{categoryID},
        ],
    );
    
    # create list of Objects
    my $resource = Magento::Backend::Resource::CatalogCategory->new(
        _connector => $connector,
    );
    my @list;
    foreach my $item (@$response) {
        # create base class
        my $new_object = Magento::Backend::Class::CatalogCategory->new(
             category_id => $item->{category_id},
             _resource => $resource,
        );
        
        # apply role and assign attributes
        apply_all_roles ($new_object,
            'Magento::Backend::Connector::XMLRPC::_Role::CatalogCategory::EntityNoChildren');
        foreach my $key (keys %$item) {
            $new_object->{$key} = $item->{$key};
        }
        
        push @list, $new_object;
    }
    
    return \@list;
} # level

sub update {
    my $self = shift;
    my $connector = shift; # from AUTOLOAD
    my %params = @_;
        
    # do some final checkup before making the call
    
    if ((! exists $params{attributeData}{default_sort_by})
        || (! exists $params{attributeData}{available_sort_by})) {
        my $current_info = $self->info(
            $connector, # oops, we need that, it will be shifted off
            categoryID => $params{categoryID},
            storeView => $params{storeView},
            attributes => [ qw(default_sort_by available_sort_by) ],
        );
        $current_info->{default_sort_by} = undef
            unless $current_info->{default_sort_by};
        $current_info->{available_sort_by} = {0=>undef}
            unless $current_info->{available_sort_by};
        
        $params{attributeData}{default_sort_by} = $current_info->{default_sort_by}
            if ! exists $params{attributeData}{default_sort_by};
        $params{attributeData}{available_sort_by} = $current_info->{available_sort_by}
            if ! exists $params{attributeData}{available_sort_by};
    }
    my $response = $connector->_client_call(
        'catalog_category.update',
        [
            $params{categoryID},
            $params{attributeData},
            $params{storeView},
        ],
    );
    
    return $response;
} # update

package Magento::Backend::Connector::XMLRPC::_Role::CatalogCategory::AssignedProduct;

use Moose::Role;

has sku => ( # Product SKU
    is  => 'ro',
);
has set_id => ( # Product attribute set
    is  => 'ro',
    writer => 'set', # this is the attribute name returned by Magento
);
has type => ( # Type of the product
    is  => 'ro',
);
has position => ( # Position of the assigned product
    is  => 'ro',
    isa => 'Int',
);

package Magento::Backend::Connector::XMLRPC::_Role::CatalogCategory::EntityNoChildren;
use Moose::Role;
has parent_id => ( # Parent category ID
    is  => 'ro',
);
has name => ( # Category name
    is  => 'ro',
);
has is_active => ( # Defines if a category is active
    is  => 'ro',
    isa => 'Int',
);
has position => ( # Category position at the level
    is  => 'ro',
    isa => 'Int',
);
has level => ( # Category level
    is  => 'ro',
    isa => 'Int',
);

1;
