#
# spdlog.cmake  umbrella for spdlog c++ logger
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  SPDLOG_REPO - url of git repository
#  SPDLOG_TAG  - tag to checkout of git
#  SPDLOG_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET spdlog)

#
# umbrella option variables
#
umbrella_defineopt (SPDLOG_REPO "https://github.com/gabime/spdlog.git"
     STRING "spdlog GIT repository")
umbrella_defineopt (SPDLOG_TAG "v1.x" STRING "spdlog GIT tag")
umbrella_defineopt (SPDLOG_TAR
     "spdlog-${SPDLOG_TAG}.tar.gz"
     STRING "spdlog cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (SPDLOG_DOWNLOAD spdlog ${SPDLOG_TAR}
                   GIT_REPOSITORY ${SPDLOG_REPO}
                   GIT_TAG ${SPDLOG_TAG})
umbrella_patchcheck (SPDLOG_PATCHCMD spdlog)

#
# depends
#
include (umbrella/fmt)

#
# create spdlog target
#
ExternalProject_Add (spdlog DEPENDS fmt
    ${SPDLOG_DOWNLOAD} ${SPDLOG_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DSPDLOG_BUILD_EXAMPLE=OFF
               -DSPDLOG_FMT_EXTERNAL=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET spdlog)
