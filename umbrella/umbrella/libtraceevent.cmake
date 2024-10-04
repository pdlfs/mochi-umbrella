#
# libtraceevent.cmake  Linux kernel trace event library
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  LIBTRACEEVENT_REPO - url of git repository
#  LIBTRACEEVENT_TAG  - tag to checkout of git
#  LIBTRACEEVENT_TAR  - cache tar file name (default should be ok)
#

umbrella_prebuilt_check(libtraceevent FILE traceevent/event-parse.h)

if (NOT TARGET libtraceevent)

#
# umbrella option variables
#
umbrella_defineopt (LIBTRACEEVENT_REPO
    "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git"
    STRING "LIBTRACEEVENT GIT repository")
umbrella_defineopt (LIBTRACEEVENT_TAG "libtraceevent" 
    STRING "LIBTRACEEVENT GIT tag")
umbrella_defineopt (LIBTRACEEVENT_TAR
    "libtraceevent-${LIBTRACEEVENT_TAG}.tar.gz" STRING
    "LIBTRACEEVENT cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (LIBTRACEEVENT_DOWNLOAD libtraceevent ${LIBTRACEEVENT_TAR}
                   GIT_REPOSITORY ${LIBTRACEEVENT_REPO}
                   GIT_TAG ${LIBTRACEEVENT_TAG})
umbrella_patchcheck (LIBTRACEEVENT_PATCHCMD libtraceevent)

#
# create psm target
#
ExternalProject_Add (libtraceevent ${LIBTRACEEVENT_DOWNLOAD}
                     ${LIBTRACEEVENT_PATCHCMD}
    CONFIGURE_COMMAND ""
    BUILD_IN_SOURCE 1      # old school makefiles
    BUILD_COMMAND make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       prefix=${CMAKE_INSTALL_PREFIX}
                       pkgconfig_dir=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig
                       libdir_relative=lib
    INSTALL_COMMAND make ${UMBRELLA_COMP}
                       ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                       prefix=${CMAKE_INSTALL_PREFIX}
                       pkgconfig_dir=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig
                       libdir_relative=lib
                       install
    UPDATE_COMMAND "")

endif (NOT TARGET libtraceevent)
