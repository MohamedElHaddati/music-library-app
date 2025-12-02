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
