#ifndef ALBUMDAO_H
#define ALBUMDAO_H

#include <vector>
#include "model/Album.h"

class AlbumDAO {
public:
    AlbumDAO();
    
    bool addAlbum(const Album& album);
    std::vector<Album> getAllAlbums();
    Album getAlbum(int id);
    bool updateAlbum(const Album& album);
    bool deleteAlbum(int id);
};

#endif // ALBUMDAO_H
