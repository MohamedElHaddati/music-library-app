cmake_minimum_required(VERSION 3.16)

project(MusicManager VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Fix: Enable AUTOMOC for Qt meta-object generation (Required for QML/Qt6)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6
find_package(Qt6 REQUIRED COMPONENTS Quick Sql Multimedia Widgets)

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
    qml/Main.qml
)

# Link libraries
target_link_libraries(MusicManager PRIVATE
    Qt6::Quick
    Qt6::Sql
    Qt6::Multimedia
    Qt6::Widgets # For QFileDialog
)

# Fix: Add src to include directories so includes like "dao/SongDAO.h" work
target_include_directories(MusicManager PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

# Copy QML files to build directory (optional, but good for keeping things together if not using qrc)
# For this assignment, we will use the QML file directly or via qrc. 
# To keep it simple and "prof-friendly" (easy to edit without recompiling resources), 
# we can load from filesystem or use qt_add_qml_module.
# Let's use the modern qt_add_qml_module if possible, or just standard resources.
# Given the "non-modern" constraint, standard QRC is safer, but loading from file is easiest for dev.
# Let's stick to standard qt_add_executable which handles resources if we add them.
# We will add a resource file or just load from relative path for simplicity.
# Loading from relative path "../qml/Main.qml" is risky across platforms/build dirs.
# We will use Qt's resource system implicitly or explicitly.
# Let's use qt_add_resources or just include qml in sources if using Qt6's new system.
# For simplicity, let's just copy the qml folder to build dir or run from source dir.
# We'll configure the target to include resources.

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
)

# Definitions
target_compile_definitions(MusicManager PRIVATE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)
