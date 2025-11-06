#ifndef ALBUM_H
#define ALBUM_H

#include <string>
#include <vector>
#include <memory>
#include "Song.h"

using namespace std;

class Album {
public:
    Album(const string& title, int releaseYear)
        : title(title), releaseYear(releaseYear) {}

    string getTitle() const { return title; }
    int getReleaseYear() const { return releaseYear; }

    void addSong(const shared_ptr<Song>& song) {
        songs.push_back(song);
    }

    const vector<shared_ptr<Song>>& getSongs() const {
        return songs;
    }

private:
    string title;
    int releaseYear;
    vector<shared_ptr<Song>> songs;
};

#endif // ALBUM_H