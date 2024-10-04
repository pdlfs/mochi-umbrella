#
# jsoncpp.cmake  json cpp file parser
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  JSONCPP_REPO - url of git repository
#  JSONCPP_TAG  - tag to checkout of git
#  JSONCPP_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET jsoncpp)

#
# umbrella option variables
#
umbrella_defineopt (JSONCPP_REPO
     "https://github.com/open-source-parsers/jsoncpp.git"
     STRING "jsoncpp GIT repository")
umbrella_defineopt (JSONCPP_TAG "master" STRING "jsoncpp GIT tag")
umbrella_defineopt (JSONCPP_TAR
     "jsoncpp-${JSONCPP_TAG}.tar.gz"
     STRING "jsoncpp cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (JSONCPP_DOWNLOAD jsoncpp ${JSONCPP_TAR}
                   GIT_REPOSITORY ${JSONCPP_REPO}
                   GIT_TAG ${JSONCPP_TAG})
umbrella_patchcheck (JSONCPP_PATCHCMD jsoncpp)

#
# create jsoncpp target
#
ExternalProject_Add (jsoncpp ${JSONCPP_DOWNLOAD} ${JSONCPP_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET jsoncpp)
