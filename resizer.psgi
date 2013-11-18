use strict;
use warnings;

use Resizer;

my $app = Resizer->apply_default_middlewares(Resizer->psgi_app);
$app;

