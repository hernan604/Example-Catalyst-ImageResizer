use strict;
use warnings;
use Test::More;
use HTTP::Request::Common qw/POST/;
#use DDP;
use Catalyst::Test 'Resizer';
use Resizer::Controller::ImageResize;
use JSON::XS;

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
  my $content_expected = <<IMG;
/9j/4AAQSkZJRgABAQAAAQABAAD//gA+Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcg
SlBFRyB2NjIpLCBkZWZhdWx0IHF1YWxpdHkK/9sAQwAIBgYHBgUIBwcHCQkICgwUDQwLCwwZEhMP
FB0aHx4dGhwcICQuJyAiLCMcHCg3KSwwMTQ0NB8nOT04MjwuMzQy/9sAQwEJCQkMCwwYDQ0YMiEc
ITIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy/8AAEQgA
MgAjAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMC
BAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYn
KCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeY
mZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5
+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwAB
AgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpD
REVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ip
qrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMR
AD8A9ve7uWupo4fJVYmCkuCSSQD2+tHnX3962/75b/GqrPt1K9H/AE0U/wDji1ma14jg0WImUNuI
yOOD/wDX9v8A65qXJJXZdOnKpJRgrsn164vo7IyttkVekcakBj/tev0/rjEulS3q6ZHOFERdMtBM
CdpBPI9ARjj/AOvXKWPjW21W9ghuMxojGTG3AYjp3PTlvwFdlLJ+6f8A3TUwkpO6Z0YijOhFU6kb
Pe5rwyebBHJjG9Q2PTNFMtB/oUH/AFzX+VFaHIeU6zP4ph8Sg2DsIjPmcGLfnpx7jrwCPwGDS+N9
H1WfREuWuxNNG4Jj8kIuMHvz09zj8TXonl7tQvTj+Nf/AEAVJ5Q9KxlSumm9z0KWYSpSpyjBJx8l
r6nhPhfTNWn1eG5k0+Y29o6yzAD5ioPZT978PevWYtbsruFhHJt3ZVNwwG7cHp+HXPBANbaWscWf
LjVM8naMZrmNR8Fi48W2/iCK8aAQjMkCJ/rGHvnuMA8HpUQpOkrR1OjFY6nmFRyre5ZaW1+T9e/Q
7a0wbOAg5Hlr/KimafGY9PgUnJ2A/nzRXSeOYur2+qTmYaVKI5BdRmX5grNHsGQrFWAPTt0B6daw
DpPjlp5Z31GAsr3HkxLLtQBkxHu+T5sMM/j+FdiLm3t7y6E0yRlnBAY4yNoqtnTvNd/7SfDE5Xz/
AJefakBycGkeMrW6tXkvlae5mijupIgGURKG3McrgNgKBjqSa0tE0vxLb3xuNZvhPEbV4yiSDbv8
wlWKhQM7TjIPb8tsvYH/AJikg4xxPSrNYx5YaiZDtK4eUEc4/wAKLDNO2/49Yf8AcH8qKLcEW0Q6
fIP5UUxEhVT1UH6ik2J/cX8qKKADYn9xfyo2J/dX8qKKAHUUUUAf/9k=
IMG

   my $decoded_res = decode_json( $res->{ _content } );
  ok( $decoded_res->{ base64 } eq $content_expected, "got expected image" );
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
  ok( $decoded_res->{ base64 } eq $content_expected, "got expected image" );
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
# warn p $res;
# use File::Slurp;
# write_file( 'imagem.png', decode_json($res->{_content})->{ base64 } );

my $content_expected = <<IMG;
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
AAAAAElFTkSuQmCC
IMG

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected, "got expected image" );
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

my $content_expected = <<IMG;
R0lGODdhIwAyAOcAADQuJISCfMTCvERCPMyGhLyqrNRGROTi3LyytMxiXOTGxNwCBNQiJMxydNTS
zNS2tKSenLySjGRiXNSipOTS1NwyNMxSVPTy7NS6tKyurNSqpNzCxNyCfNxiZNwSFNxydHRybOTa
3Ozq5NQqLNza1EQ6NMzKxNRKTLy6tKSmpOSSlNx6fJyalFxSTNwKDOSyrOSinMw+PNRaXOS6tOSq
rNyKjNxqbHx6dNSenNSKhMxqZOTOzNzS1HRuZPz6/LS2tNQeHPTa3OQqLOSanDw2LIyKhMzGxExC
PMyinOzm5OQCBNR6fNyipPTW1Ny6vLSurNyurNTOzORybOza3PTu7NwqLOROTMS+vKympNw6POSK
jORqbMTGxNSChORGROTm5MSytNwiJNRydNTW1NyyrKSinGxmXOzS1NRWVPT29NSurHxybOzu7Nze
3EQ+NMzOzNxKTLy+vOR+fOS2tNxaXIR6dNyanNRubOzKzNwaHJSOjExGPMyqrLSyrKyqpDwyLMTC
xNQ6NNxCROzCxNzKzMxmZOSmpOS+vNSOjMxubMympNy2tHx2dIR+fLy2tNwGBNSmpOTW1Nw2NMxW
VNzGxNxmZNwWFNx2dOTe3NQuLNx+fFxWTNwODOSurNyOjNxubNzW1Pz+/OSenOQGBNympNy+vOze
3NwuLNw+POSOjORubNSGhNwmJNR2dNxOTNxeXNyenOzOzNweHOTi5NTS1PTy9NS6vNSqrNyChOzq
7Nza3MzKzLy6vJyanOSytHRubDw2NIyKjORydKSipGxmZEQ+PExGRLSytKyqrAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAIwAyAAAI/gBDCRxI
sKBBH29+oBhjsKFDh0lS0AoRadcwKg8zNqyVYgqNQYOm5Br20EcULruMoFSZciVKLlh0GYqVKtUZ
hH1Q0ioYZ1cbXW1+BgUqtCieWHKECZNT64JQQDsHPsmVplbVq1azXk0zKNaHLZ9UsdHa5g3BDLlq
NVV7ga3btVNeDLGxRZTatW12EXzyhY3fv4AD+801hMYOwXnPzmJDhfFYx41rOZZ8ZoUIyI51mR14
7EAuNp9BixYdOlcuFTM+qwadS/PeNrn6ms4lYrbp2rQjffpC23bsMVEIHtPF+4vx48YPGPKEqIaC
Gp2KIxfxZcxmgcONx6bNO9chTYtI/qmw86JDCEzFuX9JQis45zHIje+gsagGEzio8qPqUErTrPhJ
fEHLdaH8MMZ/X8zy3yyQuGJHFhBGmAUdUAyR4IIJvhGVQD9EcaFx/4lyiyAVSFJiBShWoMUK6CXo
ooYDJYHMFWNgouCNnsAixI488ugKKaDMcsCNs8CIXQSK2AJJFEQd0IYnVUQZpRBVUFkBJge4mOUB
Ro7hiAU5PLLAKRuo4YkNcFSRhyxhhMGmm2FcqeCQs7TxhZFcFNBKJgv0CUQMCRDABxJ9KvEIJ5xY
ougrThpnZ4ZRAYLAHQb0ucAEpQhFQqWFLqCEp10EFVSdQRnBUCgO8DLJBIEAkYgY/hq0QeoDfFq6
wCOFjMABJncw4WSdXIAiUC0ZgGHBB128QsCcs2AiAyINjOCCJQYockAUJ7hCiA4riAIFJrucGoou
GbxhCx88DOlinV2gcQkiq1SyQYKYLHHKDDgg0UUrb8QxkA8/0BLfwLpgAMmSCBp3CytwKFHFIbrE
kYRAAIMiAnW5BMhdxtJth/EXdighMhx3bujIGLGxxp3KuPUmWy6wfKqEIF9EsZkPvOgyGBuX7XxZ
aICpdgAqSngARRuAzDIQL20IBnTQowE2CyWgsAFKHGlQHEfTjTWGmWBdf30BG2Ns6EMcmEimdmRj
1UKF22o9pnbbjOkibihxLHbX/t5xV9U233yzYfe/eWPFRhpXHa5WGseUAfjhirch7EBXzFJV2bWE
ywYjwVAxxi61FAECCY6KwEUuPQTTVhvinv1FGsGUEIAAIADgCDB7OPDLAEXoAcIvARCjxx7EoADA
HpZLThAgrx/RRxpPHPFHCr+wMMYRxpihxy9GuFECCSAQAYgEECCOSeuAUHVDMUU00gIwZTRyBBZE
tGBGMGukcUQLtdxwRC+MOMLrZqGLfzHPB7Uwwi7YwIsxJIENcWADVHRRJ1oAAwVpSEkacnGFWvhg
FndLnw/S4IMRlpCEJTThCONQBhSS8IVp+EIBKcYFEaQwazccYShOuMMU+rCHtzL81+lwOEK/XMUH
B7BKD3WYNRIezgdBpCEbSrjDCxyjDwK4Qhxq0RMuaXEMLIkCLRzwBBJ+oQ0E4cIUeWiCXUAFEGk4
gC5spgtQOOBzu3iDA77ACxKKYIY7NMIU/0VFH/Rwh4cspCLPKEQ2HJJiiDSkJCEZyUi2hiCClKQP
N8nJThYRkD5Q42qeJphSBqY6BGkDL1bJix/E4QetjCUsZynLWsYSI/+amy7lxstdzi1rGgmmMEMR
EAA7
IMG

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected, "got expected image" );
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
  ok( decode_json($res->{_content})->{error} eq 'Image file does not exists' , 'got error message as expected' );
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

my $content_expected = <<IMG;
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
IMG

   my $img = decode_json( $res->{ _content } );
  ok( $img->{ base64 } eq $content_expected, "got expected image" );
  ok( $img->{ format } eq 'png', "format is png" );
}

done_testing();
