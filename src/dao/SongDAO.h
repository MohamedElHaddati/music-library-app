#ifndef SONGDAO_H
#define SONGDAO_H

#include <vector>
#include "model/Song.h"

class SongDAO {
public:
    SongDAO();
    bool addSong(const Song& song);
    std::vector<Song> getAllSongs();
    std::vector<Song> searchSongs(const QString& query);
    bool deleteSong(int id);
    Song getSong(int id);
};

#endif // SONGDAO_H
