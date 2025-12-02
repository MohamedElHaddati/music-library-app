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
    
    Q_INVOKABLE void createPlaylist(const QString& name);

signals:
    void songsChanged();
    void albumsChanged();
    void playlistsChanged();

private:
    SongDAO m_songDAO;
    AlbumDAO m_albumDAO;
    PlaylistDAO m_playlistDAO;
};

#endif // MUSICCONTROLLER_H
