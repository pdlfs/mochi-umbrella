#
# warabi.cmake  umbrella for mochi warabi
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  WARABI_REPO - url of git repository
#  WARABI_TAG  - tag to checkout of git
#  WARABI_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET warabi)

#
# umbrella option variables
#
umbrella_defineopt (WARABI_REPO
     "https://github.com/mochi-hpc/mochi-warabi.git"
     STRING "warabi GIT repository")
umbrella_defineopt (WARABI_TAG "main" STRING "warabi GIT tag")
umbrella_defineopt (WARABI_TAR
     "warabi-${WARABI_TAG}.tar.gz"
     STRING "warabi cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (WARABI_DOWNLOAD warabi ${WARABI_TAR}
                   GIT_REPOSITORY ${WARABI_REPO}
                   GIT_TAG ${WARABI_TAG})
umbrella_patchcheck (WARABI_PATCHCMD warabi)

#
# depends
#
include (umbrella/abt-io)
include (umbrella/fmt)
include (umbrella/nlohmann-json-schema-validator)
include (umbrella/pmdk)
include (umbrella/spdlog)
include (umbrella/thallium)
include (umbrella/tclap)

#
# create warabi target
#
ExternalProject_Add (warabi DEPENDS abt-io fmt nlohmann-json-schema-validator
         pmdk spdlog thallium tclap
    ${WARABI_DOWNLOAD} ${WARABI_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET warabi)
