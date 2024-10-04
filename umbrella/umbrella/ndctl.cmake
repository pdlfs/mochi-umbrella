#
# ndctl.cmake  umbrella for libnvdimm sub-sytem mgt library
# 19-Apr-2021  chuck@ece.cmu.edu
#

#
# config:
#  NDCTL_REPO - url of git repository
#  NDCTL_TAG  - tag to checkout of git
#  NDCTL_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET ndctl)

#
# umbrella option variables
#
umbrella_defineopt (NDCTL_REPO "https://github.com/pmem/ndctl.git"
                    STRING "NDCTL GIT repository")
umbrella_defineopt (NDCTL_TAG "main" STRING "NDCTL GIT tag")
umbrella_defineopt (NDCTL_TAR "ndctl-${NDCTL_TAG}.tar.gz" STRING "NDCTL cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (NDCTL_DOWNLOAD ndctl ${NDCTL_TAR}
                   GIT_REPOSITORY ${NDCTL_REPO}
                   GIT_TAG ${NDCTL_TAG})
umbrella_patchcheck (NDCTL_PATCHCMD ndctl)

#
# depends
#
include (umbrella/iniparser)
include (umbrella/json-c)
include (umbrella/keyutils)
include (umbrella/kmod)
include (umbrella/libtraceevent)
include (umbrella/libtracefs)
include (umbrella/libuuid)

#
# XXX: ndctl has been switched to the python-based meson build
# that requires ninja as a backend.  for now, we need these tools
# preinstalled.  if they are not there, then we error out.
#
find_program(NDCTL_NINJA ninja)
find_program(NDCTL_MESON meson)
if (NOT NDCTL_NINJA)
    message(FATAL_ERROR "ndctl: need an installed ninja (and meson) to build")
endif()
if (NOT NDCTL_MESON)
    message(FATAL_ERROR "ndctl: need an installed meson package to build")
endif()

#
# create ndctl target
#
ExternalProject_Add (ndctl DEPENDS iniparser json-c keyutils kmod libtraceevent
                                   libtracefs libuuid
    ${NDCTL_DOWNLOAD} ${NDCTL_PATCHCMD}
    CONFIGURE_COMMAND env ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
        ${UMBRELLA_PKGCFGPATH}
        meson setup -Ddocs=disabled -Dsystemd=disabled
        -Drootprefix=${CMAKE_INSTALL_PREFIX}
        -Dbashcompletiondir=${CMAKE_INSTALL_PREFIX}/share/bash-completion
        --prefix=${CMAKE_INSTALL_PREFIX} --libdir=lib --libexecdir=libexec
        --mandir=share/man --sysconfdir=etc --wrap-mode=nodownload
        --buildtype=plain --backend=ninja --default-library=shared
        --cmake-prefix-path=${CMAKE_PREFIX_PATH} <SOURCE_DIR> .
    BUILD_COMMAND ninja
    INSTALL_COMMAND ninja install
    UPDATE_COMMAND "")

endif (NOT TARGET ndctl)
