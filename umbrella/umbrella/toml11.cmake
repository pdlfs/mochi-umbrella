#
# toml11.cmake  umbrella for toml11
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  TOML11_REPO - url of git repository
#  TOML11_TAG  - tag to checkout of git
#  TOML11_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET toml11)

#
# umbrella option variables
#
umbrella_defineopt (TOML11_REPO
     "https://github.com/ToruNiina/toml11.git"
     STRING "toml11 GIT repository")
umbrella_defineopt (TOML11_TAG "main" STRING "toml11 GIT tag")
umbrella_defineopt (TOML11_TAR
     "toml11-${TOML11_TAG}.tar.gz"
     STRING "toml11 cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (TOML11_DOWNLOAD toml11 ${TOML11_TAR}
                   GIT_REPOSITORY ${TOML11_REPO}
                   GIT_TAG ${TOML11_TAG})
umbrella_patchcheck (TOML11_PATCHCMD toml11)

#
# create toml11 target
#
ExternalProject_Add (toml11
    ${TOML11_DOWNLOAD} ${TOML11_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET toml11)
