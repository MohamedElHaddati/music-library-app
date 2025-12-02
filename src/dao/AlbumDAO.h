#ifndef ALBUMDAO_H
#define ALBUMDAO_H

#include <vector>
#include "model/Album.h"

class AlbumDAO {
public:
    AlbumDAO();
    std::vector<Album> getAllAlbums();
    bool addAlbum(const Album& album);
};

#endif // ALBUMDAO_H
