#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Resizer';

#entry point to test resizer
ok( request('/resize-test')->is_success, 'Request should succeed' );

done_testing();
