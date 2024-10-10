#
# yokan.cmake  umbrella for mochi yokan
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  YOKAN_REPO - url of git repository
#  YOKAN_TAG  - tag to checkout of git
#  YOKAN_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET yokan)

#
# umbrella option variables
#
umbrella_defineopt (YOKAN_REPO
     "https://github.com/mochi-hpc/mochi-yokan.git"
     STRING "yokan GIT repository")
umbrella_defineopt (YOKAN_TAG "main" STRING "yokan GIT tag")
umbrella_defineopt (YOKAN_TAR
     "yokan-${YOKAN_TAG}.tar.gz"
     STRING "yokan cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (YOKAN_DOWNLOAD yokan ${YOKAN_TAR}
                   GIT_REPOSITORY ${YOKAN_REPO}
                   GIT_TAG ${YOKAN_TAG})
umbrella_patchcheck (YOKAN_PATCHCMD yokan)

#
# depends
#
include (umbrella/margo)
include (umbrella/nlohmann-json)
include (umbrella/tclap)

#
# create yokan target
#
ExternalProject_Add (yokan DEPENDS margo nlohmann-json tclap
    ${YOKAN_DOWNLOAD} ${YOKAN_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET yokan)
