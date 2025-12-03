#ifndef PLAYLISTDAO_H
#define PLAYLISTDAO_H

#include <vector>
#include "model/Playlist.h"

class PlaylistDAO {
public:
    PlaylistDAO();
    
    bool addPlaylist(const Playlist& playlist);
    std::vector<Playlist> getAllPlaylists();
    Playlist getPlaylist(int id);
    bool deletePlaylist(int id);
    bool addSongToPlaylist(int playlistId, int songId);
    bool removeSongFromPlaylist(int playlistId, int songId);
    std::vector<int> getSongIds(int playlistId);  // Add this line
};

#endif // PLAYLISTDAO_H
