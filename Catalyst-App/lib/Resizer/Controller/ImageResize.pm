package Resizer::Controller::ImageResize;
use Moose;
use namespace::autoclean;

BEGIN { extends 'ResizerRole' }

=head1 NAME

Resizer::Controller::ImageResize - Catalyst Controller

=head1 DESCRIPTION

This class extends the ResizerRole.

=encoding utf8

=head1 AUTHOR

hernan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
