#ifndef PLAYLISTDAO_H
#define PLAYLISTDAO_H

#include <vector>
#include "model/Playlist.h"

class PlaylistDAO {
public:
    PlaylistDAO();
    std::vector<Playlist> getAllPlaylists();
    bool addPlaylist(const QString& title);
    bool addSongToPlaylist(int playlistId, int songId);
    std::vector<int> getSongIds(int playlistId);
};

#endif // PLAYLISTDAO_H
