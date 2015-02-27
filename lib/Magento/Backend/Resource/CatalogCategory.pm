package Magento::Backend::Resource::CatalogCategory;

use Moose;

with 'Magento::Backend::Resource';

sub assignedProducts {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->assignedProducts(%params);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

sub assignProduct {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->assignProduct(%params);
    return $result;
}

sub createCategory {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->createCategory(%params);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

# sub delete { # bad name, it deletes all subcategories as well
# }

sub deleteBranch {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->deleteBranch(%params);
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
}

sub get {
    my $self = shift;
    my $attribute = shift;
    my %params = @_;
    $params{attributes} = [ ($attribute) ];
    my $result = $self->info(%params);
    return $result->{$attribute};
}

sub info {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->info(%params);
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

sub levelCategories {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->levelCategories(%params);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

# sub listCategories { # this is not implemented in Magento API at all
#     my $self = shift;
#     my %params = @_;
#     my $result = $self->_connector->listCategories(%params);
#     return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
#     return $result;
# }

# sub move {
# }

# sub removeProduct {
# }

sub set {
    my $self = shift;
    my $attribute = shift;
    my $value = shift;
    my %params = @_;
    $params{categoryData} = {$attribute => $value};
    my $result = $self->update(%params);
    return $result;
}

# sub tree {
# }

sub update {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->update(%params);
    return $result;
}

# sub updateProduct {
# }

1;
