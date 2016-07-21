Ubuntu Docker with PHP and Ruby container
====================

> Containers that can use the php and ruby
> PHP is installed in phpbrew.
> Ruby is installed in rbenv.

Installation
-----

The easiest way to do this is to get from Docker registry

```sh
$ docker pull kazu69/ubuntu:php-ruby
```

Also possible to use or from github to get

```sh
$ git clone https://github.com/kazu69/docker-ubuntu.git
$ cd docker-ubuntu
$ docker build -t kazu69/docker-ubuntu .
```

If you want to add version php-version or ruby-version,
Please pull request to append to the file.
