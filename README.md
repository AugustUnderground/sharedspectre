# SharedSpectre

Shared Library for communicating with Cadence Spectre.

[Documentation](https://augustunderground.github.io/sharedspectre)

## Build

```sh
$ gmake
```

This will create a `./lib` directory containing `libspectre.so`

## Install

Install system wide:

```sh
$ gmake install
```

This will install the library and header file globally for all users. Requires
`sudo` privileges.

## Examples

The `./example` directory contains demos on how to access the shared library
from other languages. These only works _after_ the libray has been built, as
they depend on the `./lib` direcotry.
