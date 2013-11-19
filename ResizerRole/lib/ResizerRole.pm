package ResizerRole;
use base 'Catalyst::Controller::REST';
use Moose;
use Image::Resize;
use MIME::Base64;
use Catalyst::Controller::REST;

=head1 SYNOPSIS

This module allows your catalyst application to have an instant image resizer

=head2 CONFIGURATION

By default the plugin will read images from 

  YourApp/root/static/images

however, you can change that appending your Catalyst-App/resizer.conf with:

  images_path "/home/username/perl/images/"

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

sub index :Path( '/imgresize' ) :ActionClass('REST') { }

=head2 validate

This method will make the following validations:

  - required parametes were passed?
  - the required image file exists?
  - do i have permission to read the file?

If if fails to comply these verifications, will detach to _error

=cut

sub validate :Private {
    my ( $self, $c, $file ) = @_;

    #check required parameters were passed
    REQUIRED_PARAMS: {
        foreach my $param ( @{ $self->required_params } ) {
            $c->detach( '_error', [ 403 ] ) if ! exists $c->req->params->{ $param };
        }
    }

    SET_FILEPATH:{ 
        if ( $c->config->{images_path} ) {
          #user has set a custom images_path on catalyst config
          $c->stash->{ plugin_resizer }->{ file } = 
            $c->path_to( '/' )
              ->new( $c->config->{images_path} )
                ->file( $c->req->params->{ image } )->stringify ;
        } else {
          #use imagespath default from root/static/images
          $c->stash->{ plugin_resizer }->{ file } = 
            $c->path_to( 'root', 'static', 'images' )
              ->file( $c->req->params->{ image } )->stringify ;
        }
    }

    FILE_EXISTS: {
        $c->detach( '_error', [ 404 ] ) if ! -e $c->stash->{ plugin_resizer }->{ file } #file exists 
                                        || ! -r $c->stash->{ plugin_resizer }->{ file };#cant access file?
    }

    INTEGER_PARAMS:{ 
        #width and height must be integer
        foreach my $param ( qw/height width/ ) {
            $c->detach( '_error', [402] ) 
                if $c->req->params->{ $param } !~ m/^\d+$/g;
            $c->stash->{ plugin_resizer }->{ $param } = $c->req->params->{ $param };
        }
    }

    VALIDATE_FORMAT:{
        #pipe join allowed formats for regex checking
        my $allowed_fmt = join('|',@{$self->allowed_formats});
        #check the requested format
        $c->stash->{ plugin_resizer }->{format}  = ( $c->req->params->{ format } and $c->req->params->{ format } =~ m/^($allowed_fmt)$/ig )
             #take the format user passed
             ? ( ( lc($c->req->params->{ format }) eq 'jpg' ) ? 'jpeg' :  lc $c->req->params->{ format } )
             #use the default format
             : 'jpeg';
    }

    KEEP_PROPORTIONS: {
        $c->stash->{ plugin_resizer }->{ proportional } = 
            (   ! exists $c->req->params->{ proportional } 
             || ( exists $c->req->params->{ proportional } 
                   and ( $c->req->params->{ proportional } == 1 
                      || $c->req->params->{ proportional } eq 'true' ) ) )
             ? 1 #default
             : 0;
    }
}

=head2 index_GET

This entry point allows request to resize images

1. You must specify the format you want, inside the request headers

2. You should build a querystring with the required fields:

  width         =>  100
  height        =>  50
  image         => "theimage.png" 

optional querystring params:

  proportional  => 0      #deactivates the default proportional property to resized images
  format        => 'jpg'  #specify the format you want the img rendered. use: jpeg, jpg, png or gif

So your request for this entry point will look like this:

  GET http://127.0.0.1:9999/imgresize?width=100&height=200&image=catalyst_logo.png

  Accept            */*
  Accept-Encoding   gzip, deflate
  Accept-Language   en-US,en;q=0.5
  Content-Type      application/json
  Host              127.0.0.1:9999
  Referer           http://127.0.0.1:9999/resize-test
  User-Agent        Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:20.0) Gecko/20100101 Firefox/20.0
  X-Requested-With  XMLHttpRequest

Or with proportional de-activated:

  GET http://127.0.0.1:9999/imgresize?width=100&height=200&image=catalyst_logo.png&proportional=0

  ...

The images are processed with Image::Resize

=cut

sub index_GET {
    my ( $self, $c ) = @_;
    $c->stash->{ plugin_resizer } = {};
    
    $c->forward( 'validate' );

    $self->status_ok(
         $c,
         entity => $self->generate_base64( $c->stash->{ plugin_resizer } ),
    );
}

#isolated inside a method so i can test it
sub generate_base64 {
    my ( $self, $args ) = @_; 

    #load the image
    my $gd      = Image::Resize
                    ->new( $args->{file} )
                    ->resize( 
                        $args->{ height }, 
                        $args->{ width }, 
                        $args->{ proportional }
                    );
    

    my $format = $args->{ format };

    return {
        base64      => encode_base64( $gd->$format ),
        format      => $format,
    };
}

=head2 _error

This method will take care of errors. Mainly used by 'validate' method

It uses some error codes to set response error messages, ie:

  403 => 'Please pass all the required parameters: '. join(', ',@{$self->required_params}),
  404 => 'Image file does not exists or not enough permissions'

=cut

sub _error :Private {
    my ( $self, $c, $error_code ) = @_;
    my $error_msg = {
        402 => 'params height and width must be integer',
        403 => 'Please pass all the required parameters: '. join(', ',@{$self->required_params}),
        404 => 'Image file does not exists or not enough permissions',
    };
    $self->status_bad_request(
         $c,
         message => ( $error_msg->{ $error_code } )
                    ? $error_msg->{ $error_code }
                    : 'Something went wrong and your request cant be processed'
    );
}

1;
