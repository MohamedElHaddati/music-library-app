#include "SongDAO.h"
#include "Database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>

SongDAO::SongDAO() {}

bool SongDAO::addSong(const Song& song) {
    QSqlQuery query;
    query.prepare("INSERT INTO songs (title, artist, album_id, duration, file_path) VALUES (:title, :artist, :album_id, :duration, :file_path)");
    query.bindValue(":title", song.getTitle());
    query.bindValue(":artist", song.getArtist());
    query.bindValue(":album_id", song.getAlbumId() == 0 ? QVariant() : song.getAlbumId());
    query.bindValue(":duration", song.getDuration());
    query.bindValue(":file_path", song.getFilePath());

    if (!query.exec()) {
        qCritical() << "Add song failed:" << query.lastError();
        return false;
    }
    return true;
}

std::vector<Song> SongDAO::getAllSongs() {
    std::vector<Song> songs;
    QSqlQuery query("SELECT id, title, artist, file_path, album_id, duration FROM songs");
    while (query.next()) {
        Song s(
            query.value("id").toInt(),
            query.value("title").toString(),
            query.value("artist").toString(),
            query.value("file_path").toString(),
            query.value("album_id").toInt(),
            query.value("duration").toInt()
        );
        songs.push_back(s);
    }
    return songs;
}

std::vector<Song> SongDAO::searchSongs(const QString& text) {
    std::vector<Song> songs;
    QSqlQuery query;
    QString searchStr = "%" + text + "%";
    query.prepare("SELECT id, title, artist, file_path, album_id, duration FROM songs WHERE title LIKE :q OR artist LIKE :q");
    query.bindValue(":q", searchStr);
    
    if (query.exec()) {
        while (query.next()) {
            Song s(
                query.value("id").toInt(),
                query.value("title").toString(),
                query.value("artist").toString(),
                query.value("file_path").toString(),
                query.value("album_id").toInt(),
                query.value("duration").toInt()
            );
            songs.push_back(s);
        }
    }
    return songs;
}

bool SongDAO::deleteSong(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM songs WHERE id = :id");
    query.bindValue(":id", id);
    return query.exec();
}

Song SongDAO::getSong(int id) {
    QSqlQuery query;
    query.prepare("SELECT id, title, artist, file_path, album_id, duration FROM songs WHERE id = :id");
    query.bindValue(":id", id);
    if (query.exec() && query.next()) {
        return Song(
            query.value("id").toInt(),
            query.value("title").toString(),
            query.value("artist").toString(),
            query.value("file_path").toString(),
            query.value("album_id").toInt(),
            query.value("duration").toInt()
        );
    }
    return Song();
}
