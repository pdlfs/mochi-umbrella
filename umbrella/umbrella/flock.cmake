#
# flock.cmake  umbrella for mochi flock
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  FLOCK_REPO - url of git repository
#  FLOCK_TAG  - tag to checkout of git
#  FLOCK_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET flock)

#
# umbrella option variables
#
umbrella_defineopt (FLOCK_REPO
     "https://github.com/mochi-hpc/mochi-flock.git"
     STRING "flock GIT repository")
umbrella_defineopt (FLOCK_TAG "main" STRING "flock GIT tag")
umbrella_defineopt (FLOCK_TAR
     "flock-${FLOCK_TAG}.tar.gz"
     STRING "flock cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (FLOCK_DOWNLOAD flock ${FLOCK_TAR}
                   GIT_REPOSITORY ${FLOCK_REPO}
                   GIT_TAG ${FLOCK_TAG})
umbrella_patchcheck (FLOCK_PATCHCMD flock)

#
# depends
#
include (umbrella/thallium)

#
# create flock target
#
ExternalProject_Add (flock DEPENDS thallium
    ${FLOCK_DOWNLOAD} ${FLOCK_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET flock)
