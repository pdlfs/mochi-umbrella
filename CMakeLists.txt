#
# CMakeLists.txt  build mochi
# 07-Feb-2018  chuck@ece.cmu.edu
#

#
# general command line config:
#
#   -DCMAKE_INSTALL_PREFIX=/usr/local      # installation prefix
#   -DCMAKE_BUILD_TYPE=RelWithDebInfo      # or Release, Debug, etc.
#      (XXX: currently only applied to cmake-based builds)
#
#   -DUMBRELLA_BUILD_TESTS=ON              # build unit tests?
#   -DUMBRELLA_SKIP_TESTS=OFF              # skip running unit tests?
#
# finding dependencies:
#
# -DCMAKE_PREFIX_PATH='/pkg'              # look for additional installs here
#
# the following also applies for configure scripts:
# -DCMAKE_INCLUDE_PATH='/pkg/include'     # extra include directories
# -DCMAKE_LIBRARY_PATH='/pkg/lib'         # extra library path
#
# note these are all cmake lists (so more than one directory can
# be specified using a semicolon to create a path).
#
# specifying alternate compilers (overrides CC/CXX environment variables):
# -DCC=/bin/cc
# -DCXX=/bin/cxx
#  (you can also use the long form names CMAKE_C_COMPILER/CMAKE_CXX_COMPILER)
#
# specifying which mpi to use by pointing at the wrappers, if mpi enabled:
# (but extern-umbrella doesn't use MPI)
# -DMPI_C_COMPILER=/usr/bin/mpicc
# -DMPI_CXX_COMPILER=/usr/bin/mpicxx
# -DMPIEXEC=/usr/bin/mpiexec
#

cmake_minimum_required (VERSION 3.0)

#
# put the umbrella scripts in our search path and include umbrella-init
# (umbrella-init needs to run before "project")
#
list (APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/umbrella")
include (umbrella-init)

#
# need to mark project as using C/CXX so we can probe for MPI
# using a compiler that may have been passed in via the command line
# or by using environment vars.
#
project (mochi-umbrella C CXX)

#
# configure umbrella for MPI and pull in the main routines
#
set (UMBRELLA_MPI 1)
include (umbrella-main)

#
# set git tags to the versions we want to stick to by default...
#
umbrella_opt_default (BMI_TAG "master")
umbrella_opt_default (CCI_TAG "3ab663e0")
umbrella_opt_default (MERCURY_TAG "master")
umbrella_opt_default (OFI_TAG "master")

#
# set other configs before we start pulling in the pieces...
#

# note: NA_INITIALLY_ON is only applied as the defaults the first time
# you run cmake.  if you want to reconfigure, change MERCURY_BMI, et al.
umbrella_opt_default (MERCURY_NA_INITIALLY_ON "bmi;cci;ofi;sm")

#
# pull in the parts
#
include (umbrella/abt-io)
include (umbrella/abt-snoozer)
include (umbrella/argobots)
include (umbrella/bake)
include (umbrella/bmi)
include (umbrella/cci)
include (umbrella/hg-bulk-pool)
include (umbrella/libev)
include (umbrella/libuuid)
include (umbrella/margo)
include (umbrella/mercury)
include (umbrella/nvml)
include (umbrella/ofi)
include (umbrella/ssg)

#
# targets we don't want by default
#
### set_property (TARGET foo PROPERTY EXCLUDE_FROM_ALL True)
