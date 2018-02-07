# mochi-umbrella

A framework for downloading, configuring, compiling, and installing 
all the mochi software.  Uses cmake's ExternalProject module.

Requirements: a compiler with standard build tools ("make"), internet
access to github.com, ANL's xgitlab, git, autotools, and cmake (3.0 or newer).

To build and install it in a directory (e.g. /tmp/mochi):

```
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/tmp/mochi ..
make
```

You may also add other directories to search for system packages
using the CMAKE_PREFIX_PATH (e.g. if libtool is installed in /pkg,
you would add -DCMAKE_PREFIX_PATH=/pkg).   Note that CMAKE_PREFIX_PATH
can take multiple directories by using ";"'s with a quoted list:
-DCMAKE_PREFIX_PATH="/pkg;/usr/opt" ...


