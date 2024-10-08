#
# fmt.cmake  umbrella for c++ fmt lib
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  FMT_REPO - url of git repository
#  FMT_TAG  - tag to checkout of git
#  FMT_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET fmt)

#
# umbrella option variables
#
umbrella_defineopt (FMT_REPO "https://github.com/fmtlib/fmt.git"
     STRING "fmt GIT repository")
umbrella_defineopt (FMT_TAG "master" STRING "fmt GIT tag")
umbrella_defineopt (FMT_TAR
     "fmt-${FMT_TAG}.tar.gz"
     STRING "fmt cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (FMT_DOWNLOAD fmt ${FMT_TAR}
                   GIT_REPOSITORY ${FMT_REPO}
                   GIT_TAG ${FMT_TAG})
umbrella_patchcheck (FMT_PATCHCMD fmt)

#
# create fmt target
#
ExternalProject_Add (fmt
    ${FMT_DOWNLOAD} ${FMT_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DFMT_TEST=OFF
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET fmt)
