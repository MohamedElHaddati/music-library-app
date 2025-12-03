#ifndef MUSICCONTROLLER_H
#define MUSICCONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include "dao/SongDAO.h"
#include "dao/AlbumDAO.h"
#include "dao/PlaylistDAO.h"

class MusicController : public QObject {
    Q_OBJECT

public:
    explicit MusicController(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getSongs();
    Q_INVOKABLE QVariantList getAlbums();
    Q_INVOKABLE QVariantList getPlaylists();
    Q_INVOKABLE QVariantList getSongsByAlbum(int albumId);
    Q_INVOKABLE QVariantList getSongsByPlaylist(int playlistId);
    Q_INVOKABLE QVariantList search(const QString &query);
    
    Q_INVOKABLE void addSong(const QString &filePath);
    Q_INVOKABLE void updateSong(int id, const QString &title, const QString &artist, int albumId);
    Q_INVOKABLE void deleteSong(int id);
    
    Q_INVOKABLE void createAlbum(const QString &title, const QString &coverPath);
    Q_INVOKABLE void createPlaylist(const QString &title);
    Q_INVOKABLE void addSongToPlaylist(int playlistId, int songId);
    
    Q_INVOKABLE void playSong(int id);
    Q_INVOKABLE void nextSong();
    Q_INVOKABLE void previousSong();
    Q_INVOKABLE QVariantMap getCurrentSong();

signals:
    void songsChanged();
    void albumsChanged();
    void playlistsChanged();
    void currentSongChanged();

private:
    SongDAO songDAO;
    AlbumDAO albumDAO;
    PlaylistDAO playlistDAO;
    
    int currentSongId;
    QList<int> currentPlaylist;
    int currentPlaylistIndex;
};

#endif // MUSICCONTROLLER_H
