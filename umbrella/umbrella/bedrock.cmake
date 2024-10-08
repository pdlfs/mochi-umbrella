#
# bedrock.cmake  umbrella for mochi bedrock
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  BEDROCK_REPO - url of git repository
#  BEDROCK_TAG  - tag to checkout of git
#  BEDROCK_TAR  - cache tar file name (default should be ok)
#

if (NOT TARGET bedrock)

#
# umbrella option variables
#
umbrella_defineopt (BEDROCK_REPO
     "https://github.com/mochi-hpc/mochi-bedrock.git"
     STRING "bedrock GIT repository")
umbrella_defineopt (BEDROCK_TAG "main" STRING "bedrock GIT tag")
umbrella_defineopt (BEDROCK_TAR
     "bedrock-${BEDROCK_TAG}.tar.gz"
     STRING "bedrock cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (BEDROCK_DOWNLOAD bedrock ${BEDROCK_TAR}
                   GIT_REPOSITORY ${BEDROCK_REPO}
                   GIT_TAG ${BEDROCK_TAG})
umbrella_patchcheck (BEDROCK_PATCHCMD bedrock)

#
# depends
#
include (umbrella/bedrock-module-api)
include (umbrella/nlohmann-json-schema-validator)
include (umbrella/tclap)
include (umbrella/toml11)

#
# create bedrock target
#
ExternalProject_Add (bedrock DEPENDS bedrock-module-api
        nlohmann-json-schema-validator tclap toml11
    ${BEDROCK_DOWNLOAD} ${BEDROCK_PATCHCMD}
    CMAKE_ARGS -DBUILD_SHARED_LIBS=ON
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET bedrock)
