#include "MusicController.h"
#include <QFileInfo>
#include <QDebug>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QMediaMetaData>
#include <QEventLoop>
#include <QTimer>

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
        
        // Get actual song count
        std::vector<int> songIds = playlistDAO.getSongIds(playlist.getId());
        map["songCount"] = static_cast<int>(songIds.size());
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
    // Get song IDs from the playlist
    std::vector<int> songIds = playlistDAO.getSongIds(playlistId);
    QVariantList result;
    
    // Fetch each song by ID
    for (int songId : songIds) {
        Song song = songDAO.getSong(songId);
        if (song.getId() != -1) {
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
    QString artist = "Unknown Artist";
    int duration = 0;
    
    // Extract metadata using QMediaPlayer
    QMediaPlayer player;
    QAudioOutput audioOutput;
    player.setAudioOutput(&audioOutput);
    player.setSource(QUrl::fromLocalFile(cleanPath));
    
    // Wait for metadata to load
    QEventLoop loop;
    QTimer timeout;
    timeout.setSingleShot(true);
    timeout.setInterval(3000); // 3 second timeout
    
    bool metadataLoaded = false;
    
    QObject::connect(&player, &QMediaPlayer::metaDataChanged, [&]() {
        // Get title from metadata
        QVariant titleVar = player.metaData().value(QMediaMetaData::Title);
        if (titleVar.isValid() && !titleVar.toString().isEmpty()) {
            title = titleVar.toString();
        }
        
        // Get artist from metadata - try multiple keys
        QVariant artistVar = player.metaData().value(QMediaMetaData::ContributingArtist);
        if (!artistVar.isValid() || artistVar.toString().isEmpty()) {
            artistVar = player.metaData().value(QMediaMetaData::AlbumArtist);
        }
        if (!artistVar.isValid() || artistVar.toString().isEmpty()) {
            artistVar = player.metaData().value(QMediaMetaData::Author);
        }
        if (artistVar.isValid() && !artistVar.toString().isEmpty()) {
            artist = artistVar.toString();
        }
        
        metadataLoaded = true;
        loop.quit();
    });
    
    QObject::connect(&player, &QMediaPlayer::durationChanged, [&](qint64 dur) {
        duration = static_cast<int>(dur / 1000); // Convert to seconds
        if (metadataLoaded) {
            loop.quit();
        }
    });
    
    QObject::connect(&timeout, &QTimer::timeout, &loop, &QEventLoop::quit);
    
    timeout.start();
    loop.exec();
    
    qDebug() << "Adding song:" << title << "by" << artist << "duration:" << duration << "seconds";
    
    Song song(-1, title, artist, cleanPath, -1, duration);
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
        emit albumsChanged();  // Add this line to refresh album song counts
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

void MusicController::deleteAlbum(int id) {
    albumDAO.deleteAlbum(id);
    emit albumsChanged();
}

void MusicController::deletePlaylist(int id) {
    playlistDAO.deletePlaylist(id);
    emit playlistsChanged();
}

void MusicController::removeSongFromPlaylist(int playlistId, int songId) {
    playlistDAO.removeSongFromPlaylist(playlistId, songId);
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
