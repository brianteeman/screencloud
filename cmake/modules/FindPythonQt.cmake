# Find PythonQt
#
# Tries the upstream CMake config first (e.g. Qt5Python39Config.cmake),
# then falls back to a manual search.
#
# PYTHONQT_FOUND       - True if PythonQt was found
# PYTHONQT_INCLUDE_DIR - Directory containing PythonQt.h
# PYTHONQT_LIBRARY     - The PythonQt library
# PYTHONQT_LIBRARIES   - All libraries needed to use PythonQt

# ------------------------------------------------------------------
# 1. Try the upstream CMake config first
# ------------------------------------------------------------------

# Try known versioned package names (Qt<N>Python<ver>).
foreach(_pqt_pkg Qt5Python39 Qt5Python38 Qt5Python310 Qt5Python311 Qt5Python312 Qt5Python313 Qt5Python314
                 Qt6Python39 Qt6Python38 Qt6Python310 Qt6Python311 Qt6Python312 Qt6Python313 Qt6Python314)
    find_package(${_pqt_pkg} QUIET CONFIG)
    if(${_pqt_pkg}_FOUND)
        set(_pqt_found_pkg ${_pqt_pkg})
        break()
    endif()
endforeach()

if(_pqt_found_pkg)
    set(_pqt_target "${_pqt_found_pkg}::${_pqt_found_pkg}")
    if(TARGET ${_pqt_target})
        if(NOT TARGET PythonQt::PythonQt)
            add_library(PythonQt::PythonQt INTERFACE IMPORTED)
            target_link_libraries(PythonQt::PythonQt INTERFACE ${_pqt_target})
        endif()
        get_target_property(PYTHONQT_INCLUDE_DIR ${_pqt_target} INTERFACE_INCLUDE_DIRECTORIES)
        set(PYTHONQT_LIBRARY   ${_pqt_target})
        set(PYTHONQT_LIBRARIES ${_pqt_target})
        set(PYTHONQT_FOUND 1)
        if(NOT PYTHONQT_FIND_QUIETLY)
            message(STATUS "Found PythonQt via upstream config: ${_pqt_target}")
        endif()
        return()
    endif()
endif()

# ------------------------------------------------------------------
# 2. Fallback: manual search
# ------------------------------------------------------------------

get_property(LIB64 GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS)
if("${LIB64}" STREQUAL "TRUE")
    set(LIB_SUFFIX 64)
else()
    set(LIB_SUFFIX "")
endif()

if(PYTHONQT_INCLUDE_DIR)
    set(PYTHONQT_FIND_QUIETLY TRUE)
endif()

# Include path suffixes — versioned and flat.
set(_pythonqt_include_suffixes
    include/Qt5Python38/PythonQt
    include/Qt5Python39/PythonQt
    include/Qt5Python310/PythonQt
    include/Qt5Python311/PythonQt
    include/Qt5Python312/PythonQt
    include/Qt5Python313/PythonQt
    include/Qt5Python314/PythonQt
    include/Qt6Python38/PythonQt
    include/Qt6Python39/PythonQt
    include/Qt6Python310/PythonQt
    include/Qt6Python311/PythonQt
    include/Qt6Python312/PythonQt
    include/Qt6Python313/PythonQt
    include/Qt6Python314/PythonQt
    include/PythonQt
    include/PythonQt5
    src
)

find_path(PYTHONQT_INCLUDE_DIR
    NAMES PythonQt.h
    PATHS
        /usr/local/include
        /usr/include
        ${CMAKE_INCLUDE_PATH}
        ${CMAKE_INSTALL_PREFIX}/include
    PATH_SUFFIXES
        ${_pythonqt_include_suffixes}
    DOC "Path to the PythonQt include directory"
)

find_library(PYTHONQT_LIBRARY
    NAMES
        Qt5Python39 Qt5Python38 Qt5Python310 Qt5Python311 Qt5Python312 Qt5Python313 Qt5Python314
        Qt6Python39 Qt6Python38 Qt6Python310 Qt6Python311 Qt6Python312 Qt6Python313 Qt6Python314
        PythonQt-Qt5-Python3.9 PythonQt-Qt5-Python3.8
        PythonQt-Qt5-Python3.10 PythonQt-Qt5-Python3.11 PythonQt-Qt5-Python3.12
        PythonQt-Qt5-Python3.13 PythonQt-Qt5-Python3.14
        PythonQt-Qt6-Python3.9 PythonQt-Qt6-Python3.8
        PythonQt-Qt6-Python3.10 PythonQt-Qt6-Python3.11 PythonQt-Qt6-Python3.12
        PythonQt-Qt6-Python3.13 PythonQt-Qt6-Python3.14
        PythonQt QtPython
    PATHS
        /usr/local/lib${LIB_SUFFIX}
        /usr/lib${LIB_SUFFIX}
    DOC "The PythonQt library"
)

mark_as_advanced(PYTHONQT_INCLUDE_DIR PYTHONQT_LIBRARY)

# On Linux, also find libutil.
if(UNIX AND NOT APPLE)
    find_library(PYTHONQT_LIBUTIL util)
    mark_as_advanced(PYTHONQT_LIBUTIL)
endif()

set(PYTHONQT_FOUND 0)
if(PYTHONQT_INCLUDE_DIR AND PYTHONQT_LIBRARY)
    add_definitions(-DPYTHONQT_USE_RELEASE_PYTHON_FALLBACK)
    set(PYTHONQT_FOUND 1)
    set(PYTHONQT_LIBRARIES ${PYTHONQT_LIBRARY} ${PYTHONQT_LIBUTIL})
endif()