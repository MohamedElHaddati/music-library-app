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

void MusicController::addSongToPlaylist(int playlistId, int songId) {
    m_playlistDAO.addSongToPlaylist(playlistId, songId);
}

QVariantList MusicController::getPlaylistSongs(int playlistId) {
    QVariantList list;
    std::vector<int> songIds = m_playlistDAO.getSongIds(playlistId);
    for (int id : songIds) {
        Song s = m_songDAO.getSong(id);
        if (s.getId() != -1) {
            QVariantMap map;
            map["id"] = s.getId();
            map["title"] = s.getTitle();
            map["artist"] = s.getArtist();
            map["path"] = s.getFilePath();
            map["albumId"] = s.getAlbumId();
            list.append(map);
        }
    }
    return list;
}

void MusicController::createAlbum(const QString& title) {
    Album a(0, title);
    if (m_albumDAO.addAlbum(a)) {
        emit albumsChanged();
    }
}

void MusicController::updateSong(int id, const QString& title, const QString& artist, int albumId) {
    Song s = m_songDAO.getSong(id);
    if (s.getId() != -1) {
        s.setTitle(title);
        s.setArtist(artist);
        s.setAlbumId(albumId);
        if (m_songDAO.updateSong(s)) {
            emit songsChanged();
        }
    }
}

QVariantList MusicController::getAlbumSongs(int albumId) {
    QVariantList list;
    std::vector<Song> allSongs = m_songDAO.getAllSongs();
    for (const Song& s : allSongs) {
        if (s.getAlbumId() == albumId) {
            QVariantMap map;
            map["id"] = s.getId();
            map["title"] = s.getTitle();
            map["artist"] = s.getArtist();
            map["path"] = s.getFilePath();
            map["albumId"] = s.getAlbumId();
            list.append(map);
        }
    }
    return list;
}

void MusicController::updateAlbum(int id, const QString& title, const QString& coverPath) {
    emit albumsChanged();
}

// --- Playback Queue Logic ---

void MusicController::loadQueue(const std::vector<Song>& songs) {
    m_queue = songs;
    m_queueIndex = 0;
    emit currentSongChanged();
}

void MusicController::playSong(int songId) {
    Song s = m_songDAO.getSong(songId);
    if (s.getId() != -1) {
        std::vector<Song> q;
        q.push_back(s);
        loadQueue(q);
    }
}

void MusicController::playAlbum(int albumId) {
    std::vector<Song> allSongs = m_songDAO.getAllSongs();
    std::vector<Song> albumSongs;
    for (const Song& s : allSongs) {
        if (s.getAlbumId() == albumId) {
            albumSongs.push_back(s);
        }
    }
    if (!albumSongs.empty()) {
        loadQueue(albumSongs);
    }
}

void MusicController::playPlaylist(int playlistId) {
    std::vector<int> ids = m_playlistDAO.getSongIds(playlistId);
    std::vector<Song> playlistSongs;
    for (int id : ids) {
        Song s = m_songDAO.getSong(id);
        if (s.getId() != -1) {
            playlistSongs.push_back(s);
        }
    }
    if (!playlistSongs.empty()) {
        loadQueue(playlistSongs);
    }
}

QVariantMap MusicController::getCurrentSong() const {
    QVariantMap map;
    if (m_queueIndex >= 0 && m_queueIndex < (int)m_queue.size()) {
        const Song& s = m_queue[m_queueIndex];
        map["id"] = s.getId();
        map["title"] = s.getTitle();
        map["artist"] = s.getArtist();
        map["path"] = s.getFilePath();
        map["albumId"] = s.getAlbumId();
        map["hasSong"] = true;
    } else {
        map["hasSong"] = false;
        map["title"] = "No Song Playing";
        map["artist"] = "";
        map["path"] = "";
    }
    return map;
}

void MusicController::nextSong() {
    if (m_queueIndex < (int)m_queue.size() - 1) {
        m_queueIndex++;
        emit currentSongChanged();
    }
}

void MusicController::previousSong() {
    if (m_queueIndex > 0) {
        m_queueIndex--;
        emit currentSongChanged();
    }
}
