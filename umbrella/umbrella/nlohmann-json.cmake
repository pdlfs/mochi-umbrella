#
# nlohmann-json.cmake  umbrella for nlohmann-json JSON C++ parser
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  NLOHMANN_JSON_REPO - url of git repository
#  NLOHMANN_JSON_TAG  - tag to checkout of git
#  NLOHMANN_JSON_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET nlohmann-json)

#
# umbrella option variables
#
umbrella_defineopt (NLOHMANN_JSON_REPO "https://github.com/nlohmann/json.git"
     STRING "nlohmann-json GIT repository")
umbrella_defineopt (NLOHMANN_JSON_TAG "master" STRING "nlohmann-json GIT tag")
umbrella_defineopt (NLOHMANN_JSON_TAR
     "nlohmann-json-${NLOHMANN_JSON_TAG}.tar.gz"
     STRING "nlohmann-json cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (NLOHMANN_JSON_DOWNLOAD nlohmann-json ${NLOHMANN_JSON_TAR}
                   GIT_REPOSITORY ${NLOHMANN_JSON_REPO}
                   GIT_TAG ${NLOHMANN_JSON_TAG})
umbrella_patchcheck (NLOHMANN_JSON_PATCHCMD nlohmann-json)

#
# create nlohmann-json target
#
ExternalProject_Add (nlohmann-json
    ${NLOHMANN_JSON_DOWNLOAD} ${NLOHMANN_JSON_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DJSON_BuildTests=OFF
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET nlohmann-json)
