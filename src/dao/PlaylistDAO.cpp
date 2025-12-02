#include "PlaylistDAO.h"
#include "Database.h"
#include <QSqlQuery>
#include <QVariant>

PlaylistDAO::PlaylistDAO() {}

std::vector<Playlist> PlaylistDAO::getAllPlaylists() {
    std::vector<Playlist> playlists;
    QSqlQuery query("SELECT id, title FROM playlists");
    while (query.next()) {
        playlists.push_back(Playlist(
            query.value("id").toInt(),
            query.value("title").toString()
        ));
    }
    return playlists;
}

bool PlaylistDAO::addPlaylist(const QString& title) {
    QSqlQuery query;
    query.prepare("INSERT INTO playlists (title) VALUES (:title)");
    query.bindValue(":title", title);
    return query.exec();
}

bool PlaylistDAO::addSongToPlaylist(int playlistId, int songId) {
    QSqlQuery query;
    query.prepare("INSERT OR IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (:pid, :sid)");
    query.bindValue(":pid", playlistId);
    query.bindValue(":sid", songId);
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
