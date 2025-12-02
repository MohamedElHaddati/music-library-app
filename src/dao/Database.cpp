#include "Database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QFile>

Database::Database() {}

Database::~Database() {
    if (m_db.isOpen()) {
        m_db.close();
    }
}

Database& Database::instance() {
    static Database instance;
    return instance;
}

bool Database::connect() {
    if (m_db.isOpen()) return true;

    m_db = QSqlDatabase::addDatabase("QSQLITE");
    
    // Store db in AppData location or local folder for portability
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    QString dbPath = dir.filePath("music.db");
    
    // For assignment purposes, let's log where the DB is
    qDebug() << "Database path:" << dbPath;

    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qCritical() << "Error: connection with database failed" << m_db.lastError();
        return false;
    }
    return true;
}

void Database::initialize() {
    if (!connect()) return;

    // Read schema from file
    // Note: In a real deployment, we'd use a resource, but for this assignment we'll try to find the file
    // relative to the executable or just hardcode the critical tables if file not found.
    // Let's try to run the queries directly here to ensure it works without path issues.
    
    QSqlQuery query;
    
    // Songs
    bool success = query.exec("CREATE TABLE IF NOT EXISTS songs ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT,"
               "title TEXT NOT NULL,"
               "artist TEXT,"
               "album_id INTEGER,"
               "duration INTEGER,"
               "file_path TEXT NOT NULL UNIQUE"
               ")");
    if (!success) qDebug() << "Failed to create songs table:" << query.lastError();

    // Albums
    success = query.exec("CREATE TABLE IF NOT EXISTS albums ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT,"
               "title TEXT NOT NULL,"
               "cover_path TEXT"
               ")");
    if (!success) qDebug() << "Failed to create albums table:" << query.lastError();

    // Playlists
    success = query.exec("CREATE TABLE IF NOT EXISTS playlists ("
               "id INTEGER PRIMARY KEY AUTOINCREMENT,"
               "title TEXT NOT NULL"
               ")");
    if (!success) qDebug() << "Failed to create playlists table:" << query.lastError();

    // Playlist Songs
    success = query.exec("CREATE TABLE IF NOT EXISTS playlist_songs ("
               "playlist_id INTEGER,"
               "song_id INTEGER,"
               "FOREIGN KEY(playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,"
               "FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE,"
               "PRIMARY KEY (playlist_id, song_id)"
               ")");
    if (!success) qDebug() << "Failed to create playlist_songs table:" << query.lastError();
    
    // Seed data if empty
    query.exec("SELECT COUNT(*) FROM songs");
    if (query.next() && query.value(0).toInt() == 0) {
        qDebug() << "Seeding sample data...";
        query.exec("INSERT INTO albums (title) VALUES ('Unknown Album')");
        query.exec("INSERT INTO songs (title, artist, file_path, album_id) VALUES ('Demo Song 1', 'Artist A', 'C:/temp/demo1.mp3', 1)");
        query.exec("INSERT INTO songs (title, artist, file_path, album_id) VALUES ('Demo Song 2', 'Artist B', 'C:/temp/demo2.mp3', 1)");
        query.exec("INSERT INTO playlists (title) VALUES ('My Favorites')");
    }
}

QSqlDatabase Database::getDatabase() const {
    return m_db;
}
