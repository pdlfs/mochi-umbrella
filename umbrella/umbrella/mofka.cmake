#
# mofka.cmake  umbrella for mochi mofka (mochi's kafka)
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  MOFKA_REPO - url of git repository
#  MOFKA_TAG  - tag to checkout of git
#  MOFKA_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET mofka)

#
# umbrella option variables
#
umbrella_defineopt (MOFKA_REPO "https://github.com/mochi-hpc/mofka.git"
     STRING "mofka GIT repository")
umbrella_defineopt (MOFKA_TAG "main" STRING "mofka GIT tag")
umbrella_defineopt (MOFKA_TAR
     "mofka-${MOFKA_TAG}.tar.gz"
     STRING "mofka cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (MOFKA_DOWNLOAD mofka ${MOFKA_TAR}
                   GIT_REPOSITORY ${MOFKA_REPO}
                   GIT_TAG ${MOFKA_TAG})
umbrella_patchcheck (MOFKA_PATCHCMD mofka)

#
# depends
#
include (umbrella/bedrock)
include (umbrella/flock)
include (umbrella/fmt)
include (umbrella/nlohmann-json-schema-validator)
include (umbrella/spdlog)
include (umbrella/thallium)
include (umbrella/warabi)
include (umbrella/yokan)

#
# create mofka target
#
ExternalProject_Add (mofka DEPENDS bedrock flock fmt
    nlohmann-json-schema-validator
    spdlog thallium warabi yokan
    ${MOFKA_DOWNLOAD} ${MOFKA_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET mofka)
