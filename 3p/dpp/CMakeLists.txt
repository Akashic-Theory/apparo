check3p(dpp 10.0.30 dpp)

if (${fetch})
    include(FetchContent)
    FetchContent_Declare(
            dpp
            GIT_REPOSITORY https://github.com/brainboxdotcc/DPP.git
            GIT_TAG v10.0.30
    )
    FetchContent_MakeAvailable(dpp)
endif ()
