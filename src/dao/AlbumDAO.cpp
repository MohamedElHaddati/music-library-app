#include "AlbumDAO.h"
#include "Database.h"
#include <QSqlQuery>
#include <QVariant>

AlbumDAO::AlbumDAO() {}

std::vector<Album> AlbumDAO::getAllAlbums() {
    std::vector<Album> albums;
    QSqlQuery query("SELECT id, title, cover_path FROM albums");
    while (query.next()) {
        albums.push_back(Album(
            query.value("id").toInt(),
            query.value("title").toString(),
            query.value("cover_path").toString()
        ));
    }
    return albums;
}

bool AlbumDAO::addAlbum(const Album& album) {
    QSqlQuery query;
    query.prepare("INSERT INTO albums (title, cover_path) VALUES (:title, :cover)");
    query.bindValue(":title", album.getTitle());
    query.bindValue(":cover", album.getCoverPath());
    return query.exec();
}
