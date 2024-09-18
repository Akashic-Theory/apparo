include(fetchHelper.cmake)

# Dependencies
add_subdirectory(dpp)

# Print status of all dependencies
if (DEFINED 3P-EXIT)
    set(errors " with errors")
endif ()
message(STATUS "Completed processing of dependencies${errors}."
               "${3P-STATUS}")
unset(3P-STATUS CACHE)
