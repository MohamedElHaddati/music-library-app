#include "AlbumDAO.h"
#include "Database.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>

AlbumDAO::AlbumDAO() {}

std::vector<Album> AlbumDAO::getAllAlbums() {
    std::vector<Album> albums;
    QSqlQuery query("SELECT id, title, cover_path FROM albums");
    
    while (query.next()) {
        int id = query.value(0).toInt();
        QString title = query.value(1).toString();
        QString coverPath = query.value(2).toString();
        albums.push_back(Album(id, title, coverPath));
    }
    
    return albums;
}

bool AlbumDAO::addAlbum(const Album& album) {
    QSqlQuery query;
    query.prepare("INSERT INTO albums (title, cover_path) VALUES (:title, :cover_path)");
    query.bindValue(":title", album.getTitle());
    query.bindValue(":cover_path", album.getCoverPath());
    
    if (!query.exec()) {
        qDebug() << "Error adding album:" << query.lastError().text();
        return false;
    }
    return true;
}

Album AlbumDAO::getAlbum(int id) {
    QSqlQuery query;
    query.prepare("SELECT id, title, cover_path FROM albums WHERE id = :id");
    query.bindValue(":id", id);
    
    if (query.exec() && query.next()) {
        return Album(
            query.value(0).toInt(),
            query.value(1).toString(),
            query.value(2).toString()
        );
    }
    
    return Album(-1, "", "");
}

bool AlbumDAO::updateAlbum(const Album& album) {
    QSqlQuery query;
    query.prepare("UPDATE albums SET title = :title, cover_path = :cover_path WHERE id = :id");
    query.bindValue(":id", album.getId());
    query.bindValue(":title", album.getTitle());
    query.bindValue(":cover_path", album.getCoverPath());
    
    if (!query.exec()) {
        qDebug() << "Error updating album:" << query.lastError().text();
        return false;
    }
    return true;
}

bool AlbumDAO::deleteAlbum(int id) {
    QSqlQuery query;
    query.prepare("DELETE FROM albums WHERE id = :id");
    query.bindValue(":id", id);
    
    if (!query.exec()) {
        qDebug() << "Error deleting album:" << query.lastError().text();
        return false;
    }
    return true;
}
