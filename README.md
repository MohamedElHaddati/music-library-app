# Music Manager

A simple C++ desktop music management application using Qt 6 and SQLite.

## Requirements
- CMake 3.16+
- Qt 6 (Core, Quick, Sql, Multimedia, Widgets)
- C++17 compiler

## Build Instructions
1. Open a terminal in the project root.
2. Run the following commands:

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

3. Run the executable:
   - Windows: `Debug\MusicManager.exe` (or just `MusicManager.exe` depending on generator)
   - Linux: `./MusicManager`

## Features
- View list of songs
- Add new songs (via file dialog)
- Delete songs
- Search songs by title/artist
- Play/Pause music
- Persistent storage using SQLite (`music.db` created in AppData)

## Architecture
- **MVC Pattern**:
  - **Model**: Plain C++ classes (`Song`, `Album`) and DAOs (`SongDAO`) for database access.
  - **View**: QML files in `qml/`.
  - **Controller**: `MusicController` bridges C++ backend to QML.

## Troubleshooting
- **Database not found**: The app creates `music.db` in your system's AppData folder. Check the console output for the exact path.
- **QML errors**: Ensure all QML files are in the correct location relative to the executable if not using QRC.
