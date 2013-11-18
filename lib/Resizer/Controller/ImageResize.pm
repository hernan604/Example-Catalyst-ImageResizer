package Resizer::Controller::ImageResize;
use Moose;
use namespace::autoclean;
use Image::Resize;
#use DDP;
use MIME::Base64;

BEGIN { extends 'Catalyst::Controller::REST' }

=head1 NAME

Resizer::Controller::ImageResize - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut



has required_params => (
    is      => 'ro',
    default => sub {
        [ qw/image width height/ ]
    }
);

has allowed_formats => (
    is      => 'ro',
    default => sub {
        [qw/jpeg png gif jpg/];
    }
);

=head2 index

=cut

sub index :Path( '/imgresize' ) :ActionClass('REST') { }

sub validate :Private {
    my ( $self, $c, $file ) = @_;

    #check required parameters were passed
    foreach my $param ( @{ $self->required_params } ) {
        $c->detach( 'index_err', [ 403 ] ) if ! exists $c->req->params->{ $param };
    }

    #define filepath
    $c->stash( file => $c->path_to( 'root', 'static', 'images' )->file( $c->req->params->{ image } )->stringify );

    #check the file exists
    $c->detach( 'index_err', [ 404 ] ) if ! -e $c->stash->{ file };
}

sub index_GET {
    my ( $self, $c ) = @_;
    $c->forward( 'validate' );
    #resize the image
    my $gd      = Image::Resize
                    ->new( $c->stash->{file} )
                    ->resize( 
                        $c->req->params->{ height }, 
                        $c->req->params->{ width }, 
                        ( exists $c->req->params->{ proportional }
                             and $c->req->params->{ proportional } == 0 ) ? 0 : 1
                    );
    
    #pipe join allowed formats for regex checking
    my $allowed_fmt = join('|',@{$self->allowed_formats});

    my $format  = ( exists $c->req->params->{ format } and $c->req->params->{ format } =~ m/^($allowed_fmt)$/ig )
                #take the format user passed
                ? ( ( lc($c->req->params->{ format }) eq 'jpg' ) ? 'jpeg' :  lc $c->req->params->{ format } )
                #use the default format
                : 'jpeg';

    $self->status_ok(
         $c,
         entity => {
             base64      => encode_base64( $gd->$format ),
             format      => $format,
         },
    );
}

sub index_err :Private {
    my ( $self, $c, $error_code ) = @_;
    my $error_msg = {
        403 => 'Please pass all the required parameters: '. join(', ',@{$self->required_params}),
        404 => 'Image file does not exists'
    };
    $self->status_bad_request(
         $c,
         message => ( exists $error_msg->{ $error_code } )
                           ? $error_msg->{ $error_code }
                    : 'Something went wrong and your request cant be processed'
    );
}

=encoding utf8

=head1 AUTHOR

hernan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
