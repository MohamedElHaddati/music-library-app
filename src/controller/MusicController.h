#ifndef MUSICCONTROLLER_H
#define MUSICCONTROLLER_H

#include <QObject>
#include <QVariant>
#include "dao/SongDAO.h"
#include "dao/AlbumDAO.h"
#include "dao/PlaylistDAO.h"

class MusicController : public QObject {
    Q_OBJECT
public:
    explicit MusicController(QObject *parent = nullptr);

    // Expose data to QML as list of maps
    Q_INVOKABLE QVariantList getSongs();
    Q_INVOKABLE QVariantList getAlbums();
    Q_INVOKABLE QVariantList getPlaylists();
    
    Q_INVOKABLE QVariantList search(const QString& query);

    Q_INVOKABLE void addSong(const QString& path);
    Q_INVOKABLE void deleteSong(int id);
    Q_INVOKABLE void updateSong(int id, const QString& title, const QString& artist, int albumId);
    
    Q_INVOKABLE void createPlaylist(const QString& name);
    Q_INVOKABLE void addSongToPlaylist(int playlistId, int songId);
    Q_INVOKABLE QVariantList getPlaylistSongs(int playlistId);

    Q_INVOKABLE void createAlbum(const QString& title);
    Q_INVOKABLE QVariantList getAlbumSongs(int albumId);
    
    // Playback Queue Logic
    Q_INVOKABLE void playSong(int songId);
    Q_INVOKABLE void playAlbum(int albumId);
    Q_INVOKABLE void playPlaylist(int playlistId);
    
    Q_INVOKABLE QVariantMap getCurrentSong() const;
    Q_INVOKABLE void nextSong();
    Q_INVOKABLE void previousSong();
    
    Q_INVOKABLE void updateAlbum(int id, const QString& title, const QString& coverPath);

signals:
    void songsChanged();
    void albumsChanged();
    void playlistsChanged();
    void currentSongChanged();

private:
    SongDAO m_songDAO;
    AlbumDAO m_albumDAO;
    PlaylistDAO m_playlistDAO;
    
    std::vector<Song> m_queue;
    int m_queueIndex = -1;
    
    void loadQueue(const std::vector<Song>& songs);
};

#endif // MUSICCONTROLLER_H
