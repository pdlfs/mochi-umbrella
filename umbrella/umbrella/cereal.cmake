#
# cereal.cmake  umbrella for cereal c++ serializer
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  CEREAL_REPO - url of git repository
#  CEREAL_TAG  - tag to checkout of git
#  CEREAL_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET cereal)

#
# umbrella option variables
#
umbrella_defineopt (CEREAL_REPO "https://github.com/USCiLab/cereal.git"
     STRING "cereal GIT repository")
umbrella_defineopt (CEREAL_TAG "master" STRING "cereal GIT tag")
umbrella_defineopt (CEREAL_TAR
     "cereal-${CEREAL_TAG}.tar.gz"
     STRING "cereal cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (CEREAL_DOWNLOAD cereal ${CEREAL_TAR}
                   GIT_REPOSITORY ${CEREAL_REPO}
                   GIT_TAG ${CEREAL_TAG})
umbrella_patchcheck (CEREAL_PATCHCMD cereal)

#
# create cereal target.  set SKIP_PERFORMANCE_COMPARISON to avoid
# needing to install boost.
#
ExternalProject_Add (cereal
    ${CEREAL_DOWNLOAD} ${CEREAL_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DSKIP_PERFORMANCE_COMPARISON=ON
               -DBUILD_TESTS=OFF -DBUILD_SANDBOX=OFF
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET cereal)
