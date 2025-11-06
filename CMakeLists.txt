cmake_minimum_required(VERSION 3.10)
project(MusicLibraryApp)

# Set C++ standard to C++17
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Add an executable
add_executable(music_app src/main.cpp)

# You can add include directories and link libraries here
# Gonna add nlohmann/json library later
# include_directories(third-party/json/include)

# Public headers for models
target_include_directories(music_app PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)
