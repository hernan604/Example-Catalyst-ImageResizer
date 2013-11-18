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
