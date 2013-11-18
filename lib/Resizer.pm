package Resizer;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in resizer.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Resizer',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Resizer - *Example of* Catalyst resizer based application

=head1 SYNOPSIS

    #Start the server:

    script/resizer_server.pl -rdp 9999

    #Make some requests
    use HTTP::Tiny;
    use DDP;
    use HTTP::Request::Common qw/POST/;

    my $ua       = HTTP::Tiny->new();
    my $content = [
        width  => 50,
        height => 50,
        image  => 'catalyst_logo.png'
    ];
    my $response = $ua->request('GET', 'http://127.0.0.1:9999/imgresize/?'. POST('', [], Content => $content)->content, {
      headers => {
        'content-type' => 'application/json'
      },
    } );

    warn p $response;

=head1 DESCRIPTION

    This is just an example of a RESTful image resizer done in catalyst

=head1 SEE ALSO

L<Resizer::Controller::Root>, L<Catalyst>

=head1 AUTHOR

hernan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
