#
# thallium.cmake  umbrella for mochi thallium
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  THALLIUM_REPO - url of git repository
#  THALLIUM_TAG  - tag to checkout of git
#  THALLIUM_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET thallium)

#
# umbrella option variables
#
umbrella_defineopt (THALLIUM_REPO
     "https://github.com/mochi-hpc/mochi-thallium.git"
     STRING "thallium GIT repository")
umbrella_defineopt (THALLIUM_TAG "main" STRING "thallium GIT tag")
umbrella_defineopt (THALLIUM_TAR
     "thallium-${THALLIUM_TAG}.tar.gz"
     STRING "thallium cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (THALLIUM_DOWNLOAD thallium ${THALLIUM_TAR}
                   GIT_REPOSITORY ${THALLIUM_REPO}
                   GIT_TAG ${THALLIUM_TAG})
umbrella_patchcheck (THALLIUM_PATCHCMD thallium)

#
# depends
#
include (umbrella/cereal)
include (umbrella/margo)

#
# create thallium target
#
ExternalProject_Add (thallium DEPENDS cereal margo
    ${THALLIUM_DOWNLOAD} ${THALLIUM_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET thallium)
