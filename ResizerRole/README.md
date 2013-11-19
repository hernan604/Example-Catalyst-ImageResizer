# SYNOPSIS

This controller allows your catalyst application to have an instant image resizer

## CONFIGURATION

By default the plugin will read images from 

    YourApp/root/static/images

however, you can change that appending your Catalyst-App/resizer.conf with:

    images_path "/home/username/perl/images/"

## validate

This method will make the following validations:

    - required parametes were passed?
    - the required image file exists?
    - do i have permission to read the file?

If if fails to comply these verifications, will detach to \_error

## index\_GET

This entry point allows request to resize images

1\. You must specify the format you want, inside the request headers

2\. You should build a querystring with the required fields:

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

## \_error

This method will take care of errors. Mainly used by 'validate' method

It uses some error codes to set response error messages, ie:

    403 => 'Please pass all the required parameters: '. join(', ',@{$self->required_params}),
    404 => 'Image file does not exists or not enough permissions'

## TESTING

A test server has been included inside dir t/ to test this controller.
