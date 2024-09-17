# - Registers options for automatically fetching a dependency vs using a local install.
#
# Provides the following options to the user:
# <PROJECT_NAME>-USE_BUNDLED_<package> - whether a bundled version of <package> should be used
#
# Will set the following variables in the parent scope:
# fetch - on if the package should be automatically fetched
#
# Will set the following internal Cache variables:
# 3P-STATUS - Appends configuration status of current dependency
# 3P-EXIT   - On if there was an error
#
function(check3p package version dep_name)
    # Process into more easily usable strings
    string(TOUPPER ${PROJECT_NAME} _proj)
    string(TOUPPER ${dep_name} _dep)
    string(CONCAT bundle ${_proj}-USE_BUNDLED_${_dep})

    # Default usage of bundled package to OFF
    if (NOT DEFINED ${proj}-USE_BUNDLED_${_dep})
        set(${bundle} OFF CACHE BOOL "Use bundled ${_dep}")
    endif ()

    # Check whether user wants to use the bundled package
    if (${bundle})
        set(fetch ON PARENT_SCOPE)
        set(3P-STATUS "${3P-STATUS}\n\t\t${_dep}\t- Bundled Install" CACHE INTERNAL "")
    else ()
        set(fetch OFF PARENT_SCOPE)

        # Search for package without version filter first to populate fields
        # in order to detect the existence of an incompatible package version
        find_package(${package} QUIET)
        find_package(${package} ${version} QUIET)

        # Check if there is a valid local installation
        if (NOT ${package}_FOUND AND NOT ${bundle})
            # No valid local install found, but user doesn't want to use bundled package
            if (EXISTS PACKAGE_VERSION AND NOT ${PACKAGE_VERSION_COMPATIBLE})
                # Incompatible Version
                message(SEND_ERROR "Found incompatible local version ${PACKAGE_VERSION} of ${_dep}\n"
                                   "Please enable ${bundle} or locally install correct version")
                set(3P-STATUS "${3P-STATUS}\n\t\t${_dep}\t- ERROR (Incompatible local version - ${PACKAGE_VERSION})" CACHE INTERNAL "")
            else ()
                # Package not found
                message(SEND_ERROR "Unable to find a local install of ${_dep}\n"
                                   "Please enable ${bundle} or locally install ${_dep}")
                set(3P-STATUS "${3P-STATUS}\n\t\t${_dep}\t- ERROR (NOT FOUND)" CACHE INTERNAL "")
            endif ()
            set(3P-EXIT ON CACHE INTERNAL "")
        else ()
            # Found a valid local installation
            set(3P-STATUS "${3P-STATUS}\n\t\t${_dep}\t- Local Install" CACHE INTERNAL "")
        endif ()
    endif ()
endfunction()
