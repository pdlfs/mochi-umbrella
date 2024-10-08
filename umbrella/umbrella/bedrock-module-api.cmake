#
# bedrock-module-api.cmake  umbrella for mochi bedrock-module-api
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  BEDROCK_MODULE_API_REPO - url of git repository
#  BEDROCK_MODULE_API_TAG  - tag to checkout of git
#  BEDROCK_MODULE_API_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET bedrock-module-api)

#
# umbrella option variables
#
umbrella_defineopt (BEDROCK_MODULE_API_REPO
     "https://github.com/mochi-hpc/mochi-bedrock-module-api.git"
     STRING "bedrock-module-api GIT repository")
umbrella_defineopt (BEDROCK_MODULE_API_TAG "main" STRING
     "bedrock-module-api GIT tag")
umbrella_defineopt (BEDROCK_MODULE_API_TAR
     "bedrock-module-api-${BEDROCK_MODULE_API_TAG}.tar.gz"
     STRING "bedrock-module-api cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (BEDROCK_MODULE_API_DOWNLOAD bedrock-module-api
                   ${BEDROCK_MODULE_API_TAR}
                   GIT_REPOSITORY ${BEDROCK_MODULE_API_REPO}
                   GIT_TAG ${BEDROCK_MODULE_API_TAG})
umbrella_patchcheck (BEDROCK_MODULE_API_PATCHCMD bedrock-module-api)

#
# depends
#
include (umbrella/fmt)
include (umbrella/nlohmann-json)
include (umbrella/spdlog)
include (umbrella/thallium)

#
# create bedrock-module-api target
#
ExternalProject_Add (bedrock-module-api
    DEPENDS fmt nlohmann-json spdlog thallium
    ${BEDROCK_MODULE_API_DOWNLOAD} ${BEDROCK_MODULE_API_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET bedrock-module-api)
