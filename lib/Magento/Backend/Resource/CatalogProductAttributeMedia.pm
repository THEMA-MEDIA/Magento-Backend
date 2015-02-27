package Magento::Backend::Resource::CatalogProductAttributeMedia;

use Moose;

with 'Magento::Backend::Resource';

sub create {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->create(%params);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

# sub delete {
# }

#   sub get {
#       my $self = shift;
#       my $attribute = shift;
#       my %params = @_;
#       $params{attributes} = [ ($attribute) ];
#       my $result = $self->info(%params);
#       return $result->{$attribute};
#   }

# sub getSpecialPrice {
# }

sub info {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->info(%params);
    return wantarray ? %$result : $result if (ref $result eq 'HASH');
    return $result;
};

sub listImages {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->listImages(%params);
    return wantarray ? @$result : $result if (ref $result eq 'ARRAY');
    return $result;
}

#   sub set {
#       my $self = shift;
#       my $attribute = shift;
#       my $value = shift;
#       my %params = @_;
#       $params{productData} = {$attribute => $value};
#       my $result = $self->update(%params);
#       return $result;
#   }

# sub setSpecialPrice {
# }

sub update {
    my $self = shift;
    my %params = @_;
    my $result = $self->_connector->update(%params);
    return $result;
}

1;
