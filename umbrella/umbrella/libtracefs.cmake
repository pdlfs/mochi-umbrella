#
# libtracefs.cmake  Linux library for accessing ftrace file system
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  LIBTRACEFS_REPO - url of git repository
#  LIBTRACEFS_TAG  - tag to checkout of git
#  LIBTRACEFS_TAR  - cache tar file name (default should be ok)
#

umbrella_prebuilt_check(libtracefs FILE tracefs/tracefs.h)

if (NOT TARGET libtracefs)

#
# umbrella option variables
#
umbrella_defineopt (LIBTRACEFS_REPO
    "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git"
    STRING "LIBTRACEFS GIT repository")
umbrella_defineopt (LIBTRACEFS_TAG "libtracefs" 
    STRING "LIBTRACEFS GIT tag")
umbrella_defineopt (LIBTRACEFS_TAR
    "libtracefs-${LIBTRACEFS_TAG}.tar.gz" STRING
    "LIBTRACEFS cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (LIBTRACEFS_DOWNLOAD libtracefs ${LIBTRACEFS_TAR}
                   GIT_REPOSITORY ${LIBTRACEFS_REPO}
                   GIT_TAG ${LIBTRACEFS_TAG})
umbrella_patchcheck (LIBTRACEFS_PATCHCMD libtracefs)

#
# depends
#
include (umbrella/libtraceevent)

#
# create libtracefs target
#
ExternalProject_Add (libtracefs DEPENDS libtraceevent
                     ${LIBTRACEFS_DOWNLOAD}
                     ${LIBTRACEFS_PATCHCMD}
    CONFIGURE_COMMAND ""
    BUILD_IN_SOURCE 1      # old school makefiles
    BUILD_COMMAND env ${UMBRELLA_PKGCFGPATH} make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       prefix=${CMAKE_INSTALL_PREFIX}
                       pkgconfig_dir=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig
                       libdir_relative=lib
    INSTALL_COMMAND env ${UMBRELLA_PKGCFGPATH} make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       prefix=${CMAKE_INSTALL_PREFIX}
                       pkgconfig_dir=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig
                       libdir_relative=lib
                       install
    UPDATE_COMMAND "")

endif (NOT TARGET libtracefs)
