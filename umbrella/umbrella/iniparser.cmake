#
# iniparser.cmake  ini file parser
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  INIPARSER_REPO - url of git repository
#  INIPARSER_TAG  - tag to checkout of git
#  INIPARSER_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET iniparser)

#
# umbrella option variables
#
umbrella_defineopt (INIPARSER_REPO "https://gitlab.com/iniparser/iniparser.git"
     STRING "iniparser GIT repository")
umbrella_defineopt (INIPARSER_TAG "main" STRING "iniparser GIT tag")
umbrella_defineopt (INIPARSER_TAR
     "INIPARSER-${INIPARSER_TAG}.tar.gz"
     STRING "iniparser cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (INIPARSER_DOWNLOAD iniparser ${INIPARSER_TAR}
                   GIT_REPOSITORY ${INIPARSER_REPO}
                   GIT_TAG ${INIPARSER_TAG})
umbrella_patchcheck (INIPARSER_PATCHCMD iniparser)

#
# create iniparser target
#
ExternalProject_Add (iniparser ${INIPARSER_DOWNLOAD} ${INIPARSER_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DBUILD_DOCS=OFF
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET iniparser)
