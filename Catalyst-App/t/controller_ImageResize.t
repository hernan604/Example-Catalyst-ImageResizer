use strict;
use warnings;
use Test::More;
use HTTP::Request::Common qw/POST/;
use Catalyst::Test 'Resizer';
use JSON::XS;

## It has been tested inside ResizerRole module.
## However, the same tests could stay here too... 
## 
## * ADD TESTS INSIDE: ../ResizerRole/t/basic.t

    RETURN_DEFAULT_TYPE_JPG: {
  my $content = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png'
  ];
  my $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
  my $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );
  my $content_expected = ResizerRole::generate_base64( undef, {
      height        => 50,
      width         => 50,
      file          => Resizer->path_to( 'root', 'static', 'images' )->file( 'catalyst_logo.png' )->stringify,
      format        => 'jpeg',
      proportional  => 1,
  } );
#use DDP;  warn p $content_expected;

   my $decoded_res = decode_json( $res->{ _content } );
  ok( $decoded_res->{ base64 } eq $content_expected->{ base64 }, "got expected image" );
  ok( $decoded_res->{ format } eq 'jpeg', "format is jpg" );









  #now test the same thing, but pass a 'jpg' as format
     $content = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png',
      format => 'jpg'
  ];
     $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
     $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );
      $decoded_res = decode_json( $res->{ _content } );
  ok( $decoded_res->{ base64 } eq $content_expected->{ base64 }, "got expected image" );
  ok( $decoded_res->{ format } eq 'jpeg', "format is jpg" );









  #and now pass 'jpeg'
     $content = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png',
      format => 'jpeg'
  ];
     $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
     $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );
      $decoded_res = decode_json( $res->{ _content } );
  ok( $decoded_res->{ base64 } eq $content_expected->{base64}, "got expected image" );
  ok( $decoded_res->{ format } eq 'jpeg', "format is jpg" );


}

IMG_AS_PNG: {
  my $content = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png',
      format => 'png',
  ];
  my $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
  my $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );

  my $content_expected = ResizerRole::generate_base64( undef, {
      height        => 50,
      width         => 50,
      file          => Resizer->path_to( 'root', 'static', 'images' )->file( 'catalyst_logo.png' )->stringify,
      format        => 'png',
      proportional  => 1,
  } );

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected->{ base64 }, "got expected image" );
  ok( $img->{ format } eq 'png', "format is png" );
}

IMG_AS_GIF: {
  my $content = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png',
      format => 'gif',
  ];
  my $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
  my $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );

  my $content_expected = ResizerRole::generate_base64( undef, {
      height        => 50,
      width         => 50,
      file          => Resizer->path_to( 'root', 'static', 'images' )->file( 'catalyst_logo.png' )->stringify,
      format        => 'gif',
      proportional  => 1,
  } );

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected->{base64}, "got expected image" );
  ok( $img->{ format } eq 'gif', "format is gif" );
}

IMG_THAT_DOESNT_EXISTS: {
  my $content = [
      width  => 50,
      height => 50,
      image  => 'this_file_doesnt_exists.png',
      format => 'gif',
  ];
  my $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
  my $res   = request( $r );
  ok( $res->{_rc} == 400 , 'error thrown');
  ok( decode_json($res->{_content})->{error} eq 'Image file does not exists or not enough permissions' , 'got error message as expected' );
}

FAIL_TO_PASS_A_REQUIRED_PARAMS: {
  my @required_params = ( qw/width height image/ );
  my $content_default = [
      width  => 50,
      height => 50,
      image  => 'catalyst_logo.png',
      format => 'gif',
  ];

  foreach my $required_param ( @required_params ) {
    my %content     = @{$content_default};
    delete $content{ $required_param };
    my @content     = %content;
    my $r           = HTTP::Request->new(
                      GET =>
                      '/imgresize/?'. POST('', [], Content => [@content])->content ,
                      [ 'content-type' => 'application/json' ] );
    my $res         = request( $r );
    ok( $res->{_rc} == 400 , 'error thrown');
    is( decode_json($res->{_content})->{error} =~ m/Please pass all the required parameters.+/ig, 1 , 'got error message as expected' );
  }
}

IMG_AS_PNG_WITH_PROPORTION: {
  my $content = [
      width        => 50,
      height       => 50,
      image        => 'catalyst_logo.png',
      format       => 'png',
      proportional => 0,
  ];
  my $r     = HTTP::Request->new(
                  GET =>
                  '/imgresize/?'. POST('', [], Content => $content)->content ,
                  [ 'content-type' => 'application/json' ] );
  my $res   = request( $r );
  ok( $res->is_success, 'Request should succeed' );


  my $content_expected = ResizerRole::generate_base64( undef, {
      height        => 50,
      width         => 50,
      file          => Resizer->path_to( 'root', 'static', 'images' )->file( 'catalyst_logo.png' )->stringify,
      format        => 'png',
      proportional  => 0,
  } );

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected->{base64}, "got expected image" );
  ok( $img->{ format } eq 'png', "format is png" );
}

HEIGHT_AND_WIDTH_NOT_AS_INTEGER:{

    HEIGHT: { 
        my $content = [
            width  => 50,
            height => 'fifty',
            image  => 'catalyst_logo.png'
        ];
        my $r     = HTTP::Request->new(
                        GET =>
                        '/imgresize/?'. POST('', [], Content => $content)->content ,
                        [ 'content-type' => 'application/json' ] );
        my $res   = request( $r );
        ok( decode_json($res->{_content})->{error} eq 'params height and width must be integer' , 'width cant be string' );
    }

    WIDTH: { 
        my $content = [
            width  => 'fifty',
            height => 50,
            image  => 'catalyst_logo.png'
        ];
        my $r     = HTTP::Request->new(
                        GET =>
                        '/imgresize/?'. POST('', [], Content => $content)->content ,
                        [ 'content-type' => 'application/json' ] );
        my $res   = request( $r );
        ok( decode_json($res->{_content})->{error} eq 'params height and width must be integer' , 'width cant be string' );
    }
}

done_testing();
