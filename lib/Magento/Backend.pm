package Magento::Backend;

use Module::Load;

use Moose;

has config => (
    is  => 'ro',
);

has _connectors => (
    is  => 'ro',
    isa => 'HashRef[Magento::Backend::Connector]',
    lazy => 1,
    default => sub { {} },
);

# convenience method to instantiate and initialize a Resource
sub newResource {
    my $self = shift;
    my $resource_name = shift;
    my $package = "Magento::Backend::Resource::" . $resource_name;
    Module::Load::load $package;
    my $resource = $package->new(
        _connector => $self->_connector_for($resource_name)
    );
    return $resource;

}

sub _connector_for {
    my $self = shift;
    my $resource_name = shift;
    my $connector = $self->_connector_type($resource_name);
    if (!exists $self->_connectors->{$connector}) {
        my $package = "Magento::Backend::Connector::".$connector;
        Module::Load::load $package;
        $self->_connectors->{$connector} = $package->new(
            _backend=>$self);
    }
    return $self->_connectors->{$connector};
};

# helper methode that returns a connector_type
# given a data-source name
# checks several defaults in the config or returns XMLRPC
#
sub _connector_type {
    my $self = shift;
    use Data::Dumper;
    my $resource_name = shift;
    return $self->config->{"Resource::".$resource_name}{connector}
        || $self->config->{"Connector::Default"}
        || "XMLRPC";
}

1;