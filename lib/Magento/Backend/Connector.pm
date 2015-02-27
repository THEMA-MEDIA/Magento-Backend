package Magento::Backend::Connector;

use Moose::Role;

has _backend => ( # holds a backreference
    is  => 'rw',
    isa => 'Magento::Backend',
    default => sub { { } },
);

# returns the config hash for a Connector
#
sub config {
    my $self = shift;
    my $package = shift;
    my ($connector) = $package =~ /.*(Connector::.*)/;
    return $self->_backend->config->{$connector};
}

no Moose;

1;