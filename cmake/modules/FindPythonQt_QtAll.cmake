# Find PythonQt_QtAll
#
# Tries the upstream CMake config first (e.g. Qt5Python39_QtAllConfig.cmake),
# then falls back to a manual search.
#
# PYTHONQT_QTALL_FOUND       - True if PythonQt_QtAll was found
# PYTHONQT_QTALL_INCLUDE_DIR - Directory containing PythonQt_QtAll.h
# PYTHONQT_QTALL_LIBRARY     - The PythonQt_QtAll library
# PYTHONQT_QTALL_LIBRARIES   - All libraries needed to use PythonQt_QtAll

# ------------------------------------------------------------------
# 1. Try the upstream CMake config first
# ------------------------------------------------------------------

foreach(_pqt_pkg Qt5Python39_QtAll Qt5Python38_QtAll Qt5Python310_QtAll
                 Qt5Python311_QtAll Qt5Python312_QtAll
                 Qt6Python39_QtAll Qt6Python38_QtAll Qt6Python310_QtAll
                 Qt6Python311_QtAll Qt6Python312_QtAll)
    find_package(${_pqt_pkg} QUIET CONFIG)
    if(${_pqt_pkg}_FOUND)
        set(_pqt_qtall_found_pkg ${_pqt_pkg})
        break()
    endif()
endforeach()

if(_pqt_qtall_found_pkg)
    set(_pqt_qtall_target "${_pqt_qtall_found_pkg}::${_pqt_qtall_found_pkg}")
    if(TARGET ${_pqt_qtall_target})
        if(NOT TARGET PythonQt::PythonQt_QtAll)
            add_library(PythonQt::PythonQt_QtAll INTERFACE IMPORTED)
            target_link_libraries(PythonQt::PythonQt_QtAll INTERFACE ${_pqt_qtall_target})
        endif()
        get_target_property(PYTHONQT_QTALL_INCLUDE_DIR ${_pqt_qtall_target} INTERFACE_INCLUDE_DIRECTORIES)
        set(PYTHONQT_QTALL_LIBRARY   ${_pqt_qtall_target})
        set(PYTHONQT_QTALL_LIBRARIES ${_pqt_qtall_target})
        set(PYTHONQT_QTALL_FOUND 1)
        if(NOT PYTHONQT_QTALL_FIND_QUIETLY)
            message(STATUS "Found PythonQt_QtAll via upstream config: ${_pqt_qtall_target}")
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

if(PYTHONQT_QTALL_INCLUDE_DIR)
    set(PYTHONQT_QTALL_FIND_QUIETLY TRUE)
endif()

# Include path suffixes — versioned and flat.
set(_pythonqt_qtall_include_suffixes
    include/Qt5Python38/PythonQt
    include/Qt5Python39/PythonQt
    include/Qt5Python310/PythonQt
    include/Qt5Python311/PythonQt
    include/Qt5Python312/PythonQt
    include/Qt6Python38/PythonQt
    include/Qt6Python39/PythonQt
    include/Qt6Python310/PythonQt
    include/Qt6Python311/PythonQt
    include/Qt6Python312/PythonQt
    include/PythonQt
    include/PythonQt5
    include/PythonQt/extensions/PythonQt_QtAll
    extensions/PythonQt_QtAll
)

find_path(PYTHONQT_QTALL_INCLUDE_DIR
    NAMES PythonQt_QtAll.h
    PATHS
        /usr/local/include
        /usr/include
        ${CMAKE_INCLUDE_PATH}
        ${CMAKE_INSTALL_PREFIX}/include
    PATH_SUFFIXES
        ${_pythonqt_qtall_include_suffixes}
    DOC "Path to the PythonQt_QtAll include directory"
)

find_library(PYTHONQT_QTALL_LIBRARY
    NAMES
        Qt5Python39_QtAll Qt5Python38_QtAll Qt5Python310_QtAll
        Qt5Python311_QtAll Qt5Python312_QtAll
        Qt6Python39_QtAll Qt6Python38_QtAll Qt6Python310_QtAll
        Qt6Python311_QtAll Qt6Python312_QtAll
        PythonQt_QtAll-Qt5-Python3.9 PythonQt_QtAll-Qt5-Python3.8
        PythonQt_QtAll-Qt5-Python3.10 PythonQt_QtAll-Qt5-Python3.11
        PythonQt_QtAll-Qt6-Python3.9 PythonQt_QtAll-Qt6-Python3.8
        PythonQt_QtAll QtPython_QtAll
    PATHS
        /usr/local/lib${LIB_SUFFIX}
        /usr/lib${LIB_SUFFIX}
    DOC "The PythonQt_QtAll library"
)

mark_as_advanced(PYTHONQT_QTALL_INCLUDE_DIR PYTHONQT_QTALL_LIBRARY)

set(PYTHONQT_QTALL_FOUND 0)
if(PYTHONQT_QTALL_INCLUDE_DIR AND PYTHONQT_QTALL_LIBRARY)
    add_definitions(-DPYTHONQT_QTALL_USE_RELEASE_PYTHON_FALLBACK)
    set(PYTHONQT_QTALL_FOUND 1)
    set(PYTHONQT_QTALL_LIBRARIES ${PYTHONQT_QTALL_LIBRARY} ${PYTHONQT_QTALL_LIBUTIL})
endif()