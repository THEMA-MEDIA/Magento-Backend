package Magento::Backend::Class::CatalogProduct;

use Moose;

with 'Magento::Backend::Class';

has product_id => ( # Product ID
    is  => 'ro',
    isa => 'Int',
    required => 1,
);

# sub delete {
# }

sub get {
    my $self = shift;
    my $attribute = shift;
    my %params = @_;
    $params{productID} = $self->{product_id};
    my $result = $self->_resource->get(
        $attribute,
        %params,
    );
    return $result;
}

# sub getSpecialPrice {
# }

sub info {
    my $self = shift;
    my %params = @_;
    $params{productID} = $self->{product_id};
    my $result = $self->_resource->info(
         %params,
    );
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

sub set {
    my $self = shift;
    my $attribute = shift;
    my $value = shift;
    my %params = @_;
    $params{productID} = $self->{product_id};
    my $result = $self->_resource->set(
        $attribute => $value,
        %params,
    );
    return $result;
}

# sub setSpecialPrice {
# }

sub update {
    my $self = shift;
    my %params = @_;
    $params{productID} = $self->{product_id};
    my $result = $self->_resource->update(
         %params,
    );
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
}

1;
