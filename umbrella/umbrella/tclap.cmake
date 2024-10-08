#
# tclap.cmake  umbrella for template c++ command line parser
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  TCLAP_BUILD - build with 'autotools' or 'cmake'
#  TCLAP_REPO  - url of git repository
#  TCLAP_TAG   - tag to checkout of git
#  TCLAP_TAR   - cache tar file name (default should be ok)
#

if (NOT TARGET tclap)

#
# umbrella option variables
#
umbrella_defineopt (TCLAP_REPO
     "https://github.com/mirror/tclap.git"
     STRING "tclap GIT repository")
# 1.2 is stable (uses autotools), 1.4 is newer (uses cmake)
umbrella_defineopt (TCLAP_TAG "1.2" STRING "tclap GIT tag")
umbrella_defineopt (TCLAP_TAR
     "tclap-${TCLAP_TAG}.tar.gz"
     STRING "tclap cache tar file")

# attempt to guess build system (but lets user override)
if ("${TCLAP_TAG}" STREQUAL "1.2")
    umbrella_defineopt (TCLAP_BUILD "autotools" STRING "tclap build system")
else()
    umbrella_defineopt (TCLAP_BUILD "cmake" STRING "tclap build system")
endif()

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (TCLAP_DOWNLOAD tclap ${TCLAP_TAR}
                   GIT_REPOSITORY ${TCLAP_REPO}
                   GIT_TAG ${TCLAP_TAG})
umbrella_patchcheck (TCLAP_PATCHCMD tclap)

#
# create tclap target based on build system selection
#
if("${TCLAP_BUILD}" STREQUAL "cmake")

    ExternalProject_Add (tclap
        ${TCLAP_DOWNLOAD} ${TCLAP_PATCHCMD}
        CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
            -DBUILD_EXAMPLES=OFF -DBUILD_UNITTESTS=OFF -DBUILD_DOC=OFF
        CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
        UPDATE_COMMAND ""
    )

    #
    # add extra step to work around broken CMakeList.txt that attempts
    # to install docs even when -DBUILD_DOC=OFF is set
    #
    ExternalProject_Add_Step (tclap fixup
        COMMAND mkdir -p docs/html
        COMMAND touch docs/index.html docs/manual.html docs/style.css
        COMMENT "fixing up issue with install when not building docs"
        DEPENDEES configure
        DEPENDERS build
        WORKING_DIRECTORY <BINARY_DIR>)

elseif("${TCLAP_BUILD}" STREQUAL "autotools")

    ExternalProject_Add (tclap ${TCLAP_DOWNLOAD} ${TCLAP_PATCHCMD}
        CONFIGURE_COMMAND <SOURCE_DIR>/configure ${UMBRELLA_COMP}
                          ${UMBRELLA_CPPFLAGS} ${UMBRELLA_LDFLAGS}
                          --prefix=${CMAKE_INSTALL_PREFIX}
        UPDATE_COMMAND "")

    #
    # add extra autogen prepare step
    #
    ExternalProject_Add_Step (tclap prepare
        COMMAND ${UMBRELLA_PREFIX}/ensure-autogen <SOURCE_DIR>/autotools.sh
        COMMENT "preparing source for configure"
        DEPENDEES update
        DEPENDERS configure
        WORKING_DIRECTORY <SOURCE_DIR>)

    #
    # add extra step to work around broken autotools that attempts
    # to install docs even when doxygen not present
    #
    ExternalProject_Add_Step (tclap fixup
        COMMAND mkdir -p docs/html
        COMMAND touch docs/index.html docs/manual.html docs/style.css
        COMMENT "fixing up issue with install when not building docs"
        DEPENDEES configure
        DEPENDERS build
        WORKING_DIRECTORY <BINARY_DIR>)

else()
    message(FATAL_ERROR "tclap - unknown build system ${TCLAP_BUILD}")
endif()

endif (NOT TARGET tclap)
