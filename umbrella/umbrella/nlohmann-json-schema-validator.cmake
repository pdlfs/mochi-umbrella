#
# nlohmann-json-schema-validator.cmake  umbrella for nlohmann-json validator
# 04-Oct-2024  chuck@ece.cmu.edu
#

#
# config:
#  NLOHMANN_JSON_SCHEMA_VALIDATOR_REPO - url of git repository
#  NLOHMANN_JSON_SCHEMA_VALIDATOR_TAG  - tag to checkout of git
#  NLOHMANN_JSON_SCHEMA_VALIDATOR_TAR  - cache tar file name
#

if (NOT TARGET nlohmann-json-schema-validator)

#
# umbrella option variables
#
umbrella_defineopt (NLOHMANN_JSON_SCHEMA_VALIDATOR_REPO
     "https://github.com/pboettch/json-schema-validator"
     STRING "nlohmann-json-schema-validator GIT repository")
umbrella_defineopt (NLOHMANN_JSON_SCHEMA_VALIDATOR_TAG "main"
     STRING "nlohmann-json-schema-validator GIT tag")
umbrella_defineopt (NLOHMANN_JSON_SCHEMA_VALIDATOR_TAR
  "nlohmann-json-schema-validator-${NLOHMANN_JSON_SCHEMA_VALIDATOR_TAG}.tar.gz"
     STRING "nlohmann-json-schema-validator cache tar file")

#
# generate parts of the ExternalProject_Add args...
#
umbrella_download (NLOHMANN_JSON_SCHEMA_VALIDATOR_DOWNLOAD
     nlohmann-json-schema-validator ${NLOHMANN_JSON_SCHEMA_VALIDATOR_TAR}
     GIT_REPOSITORY ${NLOHMANN_JSON_SCHEMA_VALIDATOR_REPO}
     GIT_TAG ${NLOHMANN_JSON_SCHEMA_VALIDATOR_TAG})
umbrella_patchcheck (NLOHMANN_JSON_SCHEMA_VALIDATOR_PATCHCMD
     nlohmann-json-schema-validator)

#
# depends
#
include (umbrella/nlohmann-json)

#
# create nlohmann-json-schema-validator target
#
ExternalProject_Add (nlohmann-json-schema-validator
     DEPENDS nlohmann-json
     ${NLOHMANN_JSON_SCHEMA_VALIDATOR_DOWNLOAD}
     ${NLOHMANN_JSON_SCHEMA_VALIDATOR_PATCHCMD}
     CMAKE_ARGS -DBUILD_SHARED_LIBS=ON -DJSON_VALIDATOR_BUILD_TESTS=OFF
                -DJSON_VALIDATOR_BUILD_EXAMPLES=OFF
    CMAKE_CACHE_ARGS ${UMBRELLA_CMAKECACHE}
    UPDATE_COMMAND ""
)

endif (NOT TARGET nlohmann-json-schema-validator)
