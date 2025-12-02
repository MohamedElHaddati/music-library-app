#include "MusicController.h"
#include <QFileInfo>
#include <QDebug>

MusicController::MusicController(QObject *parent) : QObject(parent) {}

QVariantList MusicController::getSongs() {
    QVariantList list;
    std::vector<Song> songs = m_songDAO.getAllSongs();
    for (size_t i = 0; i < songs.size(); ++i) {
        QVariantMap map;
        map["id"] = songs[i].getId();
        map["title"] = songs[i].getTitle();
        map["artist"] = songs[i].getArtist();
        map["path"] = songs[i].getFilePath();
        map["albumId"] = songs[i].getAlbumId();
        list.append(map);
    }
    return list;
}

QVariantList MusicController::getAlbums() {
    QVariantList list;
    std::vector<Album> albums = m_albumDAO.getAllAlbums();
    for (size_t i = 0; i < albums.size(); ++i) {
        QVariantMap map;
        map["id"] = albums[i].getId();
        map["title"] = albums[i].getTitle();
        map["cover"] = albums[i].getCoverPath();
        list.append(map);
    }
    return list;
}

QVariantList MusicController::getPlaylists() {
    QVariantList list;
    std::vector<Playlist> playlists = m_playlistDAO.getAllPlaylists();
    for (size_t i = 0; i < playlists.size(); ++i) {
        QVariantMap map;
        map["id"] = playlists[i].getId();
        map["title"] = playlists[i].getTitle();
        list.append(map);
    }
    return list;
}

QVariantList MusicController::search(const QString& query) {
    QVariantList list;
    std::vector<Song> songs = m_songDAO.searchSongs(query);
    for (size_t i = 0; i < songs.size(); ++i) {
        QVariantMap map;
        map["id"] = songs[i].getId();
        map["title"] = songs[i].getTitle();
        map["artist"] = songs[i].getArtist();
        map["path"] = songs[i].getFilePath();
        list.append(map);
    }
    return list;
}

void MusicController::addSong(const QString& path) {
    // Simple logic: use filename as title, unknown artist
    // Remove "file:///" prefix if present (common in QML)
    QString cleanPath = path;
    if (cleanPath.startsWith("file:///")) {
        cleanPath = cleanPath.mid(8);
    }
    
    QFileInfo info(cleanPath);
    Song s(0, info.baseName(), "Unknown Artist", cleanPath);
    
    if (m_songDAO.addSong(s)) {
        emit songsChanged();
    }
}

void MusicController::deleteSong(int id) {
    if (m_songDAO.deleteSong(id)) {
        emit songsChanged();
    }
}

void MusicController::createPlaylist(const QString& name) {
    if (m_playlistDAO.addPlaylist(name)) {
        emit playlistsChanged();
    }
}
