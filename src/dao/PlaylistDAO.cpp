#include "PlaylistDAO.h"
#include "Database.h"
#include <QSqlQuery>
#include <QSqlError>  // Add this line
#include <QVariant>
#include <QDebug>

PlaylistDAO::PlaylistDAO() {}

std::vector<Playlist> PlaylistDAO::getAllPlaylists() {
    std::vector<Playlist> playlists;
    QSqlQuery query("SELECT id, title FROM playlists");
    while (query.next()) {
        int id = query.value(0).toInt();
        QString title = query.value(1).toString();
        playlists.push_back(Playlist(id, title));
    }
    return playlists;
}

bool PlaylistDAO::addPlaylist(const Playlist& playlist) {
    QSqlQuery query;
    query.prepare("INSERT INTO playlists (title) VALUES (:title)");
    query.bindValue(":title", playlist.getTitle());
    
    if (!query.exec()) {
        qDebug() << "Error adding playlist:" << query.lastError().text();
        return false;
    }
    return true;
}

Playlist PlaylistDAO::getPlaylist(int id) {
    QSqlQuery query;
    query.prepare("SELECT id, title FROM playlists WHERE id = :id");
    query.bindValue(":id", id);
    
    if (query.exec() && query.next()) {
        return Playlist(query.value(0).toInt(), query.value(1).toString());
    }
    
    return Playlist(-1, "");
}

bool PlaylistDAO::deletePlaylist(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM playlists WHERE id = :id");
    query.bindValue(":id", id);
    return query.exec();
}

bool PlaylistDAO::addSongToPlaylist(int playlistId, int songId) {
    QSqlQuery query;
    query.prepare("INSERT OR IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (:playlist_id, :song_id)");
    query.bindValue(":playlist_id", playlistId);
    query.bindValue(":song_id", songId);
    
    if (!query.exec()) {
        qDebug() << "Error adding song to playlist:" << query.lastError().text();
        return false;
    }
    return true;
}

bool PlaylistDAO::removeSongFromPlaylist(int playlistId, int songId) {
    QSqlQuery query;
    query.prepare("DELETE FROM playlist_songs WHERE playlist_id = :playlist_id AND song_id = :song_id");
    query.bindValue(":playlist_id", playlistId);
    query.bindValue(":song_id", songId);
    return query.exec();
}

std::vector<int> PlaylistDAO::getSongIds(int playlistId) {
    std::vector<int> ids;
    QSqlQuery query;
    query.prepare("SELECT song_id FROM playlist_songs WHERE playlist_id = :pid");
    query.bindValue(":pid", playlistId);
    if (query.exec()) {
        while (query.next()) {
            ids.push_back(query.value(0).toInt());
        }
    }
    return ids;
}
