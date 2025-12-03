cmake_minimum_required(VERSION 3.16)

project(MusicManager VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Fix: Enable AUTOMOC for Qt meta-object generation (Required for QML/Qt6)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Multimedia Widgets QuickControls2)

# Fix: Set Qt policy to suppress warning about default resource prefix
if(COMMAND qt_policy)
    qt_policy(SET QTP0001 NEW)
endif()

# Source files
set(SOURCES
    src/main.cpp
    src/model/Song.cpp
    src/model/Album.cpp
    src/model/Playlist.cpp
    src/dao/Database.cpp
    src/dao/SongDAO.cpp
    src/dao/AlbumDAO.cpp
    src/dao/PlaylistDAO.cpp
    src/controller/MusicController.cpp
)

set(HEADERS
    src/model/Song.h
    src/model/Album.h
    src/model/Playlist.h
    src/dao/Database.h
    src/dao/SongDAO.h
    src/dao/AlbumDAO.h
    src/dao/PlaylistDAO.h
    src/controller/MusicController.h
)

# Add executable
qt_add_executable(MusicManager
    MANUAL_FINALIZATION
    ${SOURCES}
    ${HEADERS}
)

# Link libraries
target_link_libraries(MusicManager PRIVATE
    Qt6::Quick
    Qt6::Sql
    Qt6::Multimedia
    Qt6::Widgets
    Qt6::QuickControls2
)

# Fix: Add src to include directories so includes like "dao/SongDAO.h" work
target_include_directories(MusicManager PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

# IMPORTANT: Set singleton property BEFORE qt_add_qml_module
set_source_files_properties(qml/AppTheme.qml 
    PROPERTIES 
    QT_QML_SINGLETON_TYPE TRUE
)

# Add QML module
qt_add_qml_module(MusicManager
    URI MusicManager
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/SongList.qml
        qml/AlbumList.qml
        qml/PlaylistList.qml
        qml/AlbumDetail.qml
        qml/PlaylistDetail.qml
        qml/PlayerControls.qml
        qml/AppTheme.qml
)

# Definitions
target_compile_definitions(MusicManager PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

# Finalize the executable
qt_finalize_target(MusicManager)