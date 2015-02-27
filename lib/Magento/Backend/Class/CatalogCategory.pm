package Magento::Backend::Class::CatalogCategory;

use Moose;

with 'Magento::Backend::Class';

has category_id => ( # Category ID
    is  => 'ro',
    isa => 'Int',
    required => 1,
);

sub assignedProducts {
    my $self = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->assignedProducts(
         %params,
    );
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

sub assignProduct {
    my $self = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->assignProducts(
         %params,
    );
    return $result;
}

sub createChild {
    my $self = shift;
    my %params = @_;
    $params{parentID} = $self->{category_id};
    my $result = $self->_resource->createCategory(
         %params,
    );
    return $result;
}

# sub delete {
# }

sub get {
    my $self = shift;
    my $attribute = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->get(
        $attribute,
        %params,
    );
    return $result;
}

sub info {
    my $self = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->info(
         %params,
    );
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

sub levelCategories {
    my $self = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->levelCategories(
         %params,
    );
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

# sub move {
# }

# sub removeProduct {
# }

sub set {
    my $self = shift;
    my $attribute = shift;
    my $value = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->set(
        $attribute => $value,
        %params,
    );
    return $result;
}

# sub tree {
# }

sub update {
    my $self = shift;
    my %params = @_;
    $params{categoryID} = $self->{category_id};
    my $result = $self->_resource->update(
         %params,
    );
    return $result;
}

# sub updateProduct {
# }

1;
