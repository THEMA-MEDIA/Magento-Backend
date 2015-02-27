package Magento::Backend::Connector::XMLRPC;

use Moose;

with 'Magento::Backend::Connector';

use XML::RPC;

has _sessionID => (
    is         => "ro",
    lazy       => 1,
    builder    => "_client_login",
    init_arg   => undef,
);

has _client => (
    is         => "ro",
    isa        => "XML::RPC",
    lazy       => 1,
    builder    => "_client_new",
    init_arg   => undef,
);


sub _client_new {
    my $self = $_[0];
    return XML::RPC->new($self->config(__PACKAGE__)->{host_url});
}

sub _client_login {
    my $self = $_[0];
    my $response = $self->_client->call(
        'login', (
            $self->config(__PACKAGE__)->{username},
            $self->config(__PACKAGE__)->{password}
        )
    );
    # TODO check for faults
    return $response;
}

sub _client_call{
    my $self = shift;
    my $methode = shift;
    my @arguments = @_;
    my $response;
    $response = $self->{_client}->call(
        'call', (
            $self->_sessionID,
            $methode,
            @arguments,
        )
    );
    # TODO check for faults
    return $response;
}

sub AUTOLOAD {
    my $connector = $_[0];
    my $method = our $AUTOLOAD;
    $method =~ s/.*:://;
    my $resource = caller;
    $resource =~ s/.*:://;
    my $module = __PACKAGE__ .'::'.$resource;
    Module::Load::load $module;
    my $result = $module->$method(@_);
    return $result;
}
1;
