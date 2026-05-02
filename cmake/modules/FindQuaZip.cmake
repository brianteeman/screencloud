# - Find quazip
# Tries the upstream CMake config first (handles versioned installs such as
# QuaZip-Qt5-1.4), then falls back to a manual search.
#
# QUAZIP_FOUND       - True if QuaZip was found
# QUAZIP_INCLUDE_DIR - Directory containing quazip.h
# QUAZIP_LIBRARIES   - Libraries to link against
# QuaZip::QuaZip     - Imported target (always available when found)

# ------------------------------------------------------------------
# 1. Try the upstream CMake config first
# ------------------------------------------------------------------

# Try both Qt5 and Qt6 variants.
find_package(QuaZip-Qt5 QUIET CONFIG)
find_package(QuaZip-Qt6 QUIET CONFIG)

if(QuaZip-Qt5_FOUND OR QuaZip-Qt6_FOUND)
    # Determine which variant was found and expose a unified imported target.
    if(QuaZip-Qt5_FOUND AND TARGET QuaZip5::QuaZip5)
        set(_quazip_target QuaZip5::QuaZip5)
    elseif(QuaZip-Qt6_FOUND AND TARGET QuaZip6::QuaZip6)
        set(_quazip_target QuaZip6::QuaZip6)
    elseif(TARGET QuaZip::QuaZip)
        set(_quazip_target QuaZip::QuaZip)
    endif()

    if(_quazip_target)
        # Expose a unified QuaZip::QuaZip alias.
        if(NOT TARGET QuaZip::QuaZip)
            add_library(QuaZip::QuaZip INTERFACE IMPORTED)
            target_link_libraries(QuaZip::QuaZip INTERFACE ${_quazip_target})
        endif()

        # Populate result variables.
        get_target_property(QUAZIP_INCLUDE_DIR ${_quazip_target}
                            INTERFACE_INCLUDE_DIRECTORIES)
        set(QUAZIP_LIBRARY     ${_quazip_target})
        set(QUAZIP_LIBRARIES   ${_quazip_target})
        set(QUAZIP_FOUND TRUE)

        if(NOT QUAZIP_FIND_QUIETLY)
            message(STATUS "Found QuaZip via upstream config: ${_quazip_target}")
        endif()
        return()
    endif()
endif()

# ------------------------------------------------------------------
# 2. Fallback: manual search
# ------------------------------------------------------------------

if(QUAZIP_INCLUDE_DIR)
    # Already in cache – be silent.
    set(QUAZIP_FIND_QUIETLY TRUE)
endif()

# Include path suffixes — versioned and flat layouts.
set(_quazip_include_suffixes
    # Versioned: QuaZip-Qt<N>-<version>/quazip/
    include/QuaZip-Qt5-1.4/quazip
    include/QuaZip-Qt5-1.5/quazip
    include/QuaZip-Qt5-1.6/quazip
    include/QuaZip-Qt6-1.4/quazip
    include/QuaZip-Qt6-1.5/quazip
    include/QuaZip-Qt6-1.6/quazip
    # Flat layouts
    include/quazip5
    include/quazip
)

find_path(QUAZIP_INCLUDE_DIR
    NAMES quazip.h
    PATHS
        ${CMAKE_INCLUDE_PATH}
        ${CMAKE_INSTALL_PREFIX}/include
        /usr/local/include
        /usr/include
    PATH_SUFFIXES
        ${_quazip_include_suffixes}
)

find_library(QUAZIP_LIBRARY
    NAMES
        quazip1-qt5
        quazip1-qt6
        quazip5
        quazip-qt5
        quazip-qt6
        quazip
        qtquazip
        QtQuazip
    PATHS
        /usr/local/lib
        /usr/lib
)

# ZLIB dependency
if(UNIX)
    find_package(ZLIB REQUIRED)
else()
    set(ZLIB_INCLUDE_DIRS "${QT_ROOT}/src/3rdparty/zlib"
        CACHE STRING "Path to ZLIB headers of Qt")
    if(NOT EXISTS "${ZLIB_INCLUDE_DIRS}/zlib.h")
        message("Please specify a valid zlib include dir")
    endif()
endif()

# Handle QUIETLY / REQUIRED and set QUAZIP_FOUND.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(QuaZip
    DEFAULT_MSG
    QUAZIP_LIBRARY
    QUAZIP_INCLUDE_DIR
)

if(QUAZIP_FOUND)
    set(QUAZIP_LIBRARIES ${QUAZIP_LIBRARY})

    # Provide an imported target for consistency with the config-file path.
    if(NOT TARGET QuaZip::QuaZip)
        add_library(QuaZip::QuaZip UNKNOWN IMPORTED)
        set_target_properties(QuaZip::QuaZip PROPERTIES
            IMPORTED_LOCATION             "${QUAZIP_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${QUAZIP_INCLUDE_DIR}"
        )
    endif()
else()
    set(QUAZIP_LIBRARIES)
endif()

mark_as_advanced(QUAZIP_LIBRARY QUAZIP_INCLUDE_DIR)
