package Resizer::View::Standard;
use strict; 
use base 'Catalyst::View::TT';
__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [
            Resizer->path_to( 'root', 'src', 'template', 'standard', ), 
        ],
    TIMER   => 0,
    WRAPPER => 'wrapper.tt2', #aqui especificamos nosso arquivo wrapper
);
1;
