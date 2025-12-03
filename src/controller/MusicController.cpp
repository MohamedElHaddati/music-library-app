#include "MusicController.h"
#include <QFileInfo>
#include <QDebug>

MusicController::MusicController(QObject *parent)
    : QObject(parent), currentSongId(-1), currentPlaylistIndex(-1) {
}

QVariantList MusicController::getSongs() {
    std::vector<Song> songsVec = songDAO.getAllSongs();
    QList<Song> songs = QList<Song>(songsVec.begin(), songsVec.end());
    
    QVariantList result;
    for (const Song& song : songs) {
        QVariantMap map;
        map["id"] = song.getId();
        map["title"] = song.getTitle();
        map["artist"] = song.getArtist();
        map["albumId"] = song.getAlbumId();
        map["duration"] = song.getDuration();
        map["path"] = song.getFilePath();
        result.append(map);
    }
    return result;
}

QVariantList MusicController::getAlbums() {
    std::vector<Album> albumsVec = albumDAO.getAllAlbums();
    QList<Album> albums = QList<Album>(albumsVec.begin(), albumsVec.end());
    
    QVariantList result;
    for (const Album& album : albums) {
        QVariantMap map;
        map["id"] = album.getId();
        map["title"] = album.getTitle();
        map["coverPath"] = album.getCoverPath();
        
        // Count songs in this album
        std::vector<Song> albumSongs = songDAO.getAllSongs();
        int count = 0;
        for (const Song& song : albumSongs) {
            if (song.getAlbumId() == album.getId()) {
                count++;
            }
        }
        map["songCount"] = count;
        result.append(map);
    }
    return result;
}

QVariantList MusicController::getPlaylists() {
    std::vector<Playlist> playlistsVec = playlistDAO.getAllPlaylists();
    QList<Playlist> playlists = QList<Playlist>(playlistsVec.begin(), playlistsVec.end());
    
    QVariantList result;
    for (const Playlist& playlist : playlists) {
        QVariantMap map;
        map["id"] = playlist.getId();
        map["title"] = playlist.getTitle();
        
        // Count songs - this needs to be implemented in PlaylistDAO
        map["songCount"] = 0; // TODO: implement getSongsByPlaylist in DAO
        result.append(map);
    }
    return result;
}

QVariantList MusicController::getSongsByAlbum(int albumId) {
    std::vector<Song> songsVec = songDAO.getAllSongs();
    QVariantList result;
    
    for (const Song& song : songsVec) {
        if (song.getAlbumId() == albumId) {
            QVariantMap map;
            map["id"] = song.getId();
            map["title"] = song.getTitle();
            map["artist"] = song.getArtist();
            map["albumId"] = song.getAlbumId();
            map["duration"] = song.getDuration();
            map["path"] = song.getFilePath();
            result.append(map);
        }
    }
    return result;
}

QVariantList MusicController::getSongsByPlaylist(int playlistId) {
    // For now, return empty list until PlaylistDAO method is implemented
    QVariantList result;
    // TODO: Implement getSongsByPlaylist in PlaylistDAO
    return result;
}

QVariantList MusicController::search(const QString& query) {
    std::vector<Song> songsVec = songDAO.getAllSongs();
    QVariantList result;
    
    QString lowerQuery = query.toLower();
    for (const Song& song : songsVec) {
        if (song.getTitle().toLower().contains(lowerQuery) ||
            song.getArtist().toLower().contains(lowerQuery)) {
            QVariantMap map;
            map["id"] = song.getId();
            map["title"] = song.getTitle();
            map["artist"] = song.getArtist();
            map["albumId"] = song.getAlbumId();
            map["duration"] = song.getDuration();
            map["path"] = song.getFilePath();
            result.append(map);
        }
    }
    return result;
}

void MusicController::addSong(const QString& filePath) {
    QString cleanPath = filePath;
    if (cleanPath.startsWith("file:///")) {
        cleanPath = cleanPath.mid(8);
    }
    
    QFileInfo info(cleanPath);
    QString title = info.baseName();
    
    Song song(-1, title, "Unknown Artist", cleanPath, -1, 0);
    songDAO.addSong(song);
    emit songsChanged();
}

void MusicController::updateSong(int id, const QString& title, const QString& artist, int albumId) {
    Song song = songDAO.getSong(id);
    if (song.getId() != -1) {
        song.setTitle(title);
        song.setArtist(artist);
        song.setAlbumId(albumId);
        songDAO.updateSong(song);
        emit songsChanged();
    }
}

void MusicController::deleteSong(int id) {
    songDAO.deleteSong(id);
    emit songsChanged();
}

void MusicController::createAlbum(const QString& title, const QString& coverPath) {
    Album album(-1, title, coverPath);
    albumDAO.addAlbum(album);
    emit albumsChanged();
}

void MusicController::createPlaylist(const QString& title) {
    Playlist playlist(-1, title);
    playlistDAO.addPlaylist(playlist);
    emit playlistsChanged();
}

void MusicController::addSongToPlaylist(int playlistId, int songId) {
    playlistDAO.addSongToPlaylist(playlistId, songId);
    emit playlistsChanged();
}

void MusicController::playSong(int id) {
    currentSongId = id;
    emit currentSongChanged();
}

void MusicController::nextSong() {
    std::vector<Song> songsVec = songDAO.getAllSongs();
    QList<Song> allSongs = QList<Song>(songsVec.begin(), songsVec.end());
    
    if (allSongs.isEmpty()) return;
    
    for (int i = 0; i < allSongs.size(); ++i) {
        if (allSongs[i].getId() == currentSongId) {
            if (i + 1 < allSongs.size()) {
                playSong(allSongs[i + 1].getId());
            } else {
                playSong(allSongs[0].getId());
            }
            return;
        }
    }
}

void MusicController::previousSong() {
    std::vector<Song> songsVec = songDAO.getAllSongs();
    QList<Song> allSongs = QList<Song>(songsVec.begin(), songsVec.end());
    
    if (allSongs.isEmpty()) return;
    
    for (int i = 0; i < allSongs.size(); ++i) {
        if (allSongs[i].getId() == currentSongId) {
            if (i > 0) {
                playSong(allSongs[i - 1].getId());
            } else {
                playSong(allSongs.last().getId());
            }
            return;
        }
    }
}

QVariantMap MusicController::getCurrentSong() {
    QVariantMap map;
    if (currentSongId == -1) {
        map["hasSong"] = false;
        map["title"] = "";
        map["artist"] = "";
        map["path"] = "";
        return map;
    }
    
    Song song = songDAO.getSong(currentSongId);
    if (song.getId() == -1) {
        map["hasSong"] = false;
        map["title"] = "";
        map["artist"] = "";
        map["path"] = "";
        return map;
    }
    
    map["hasSong"] = true;
    map["id"] = song.getId();
    map["title"] = song.getTitle();
    map["artist"] = song.getArtist();
    map["path"] = "file:///" + song.getFilePath();
    return map;
}
