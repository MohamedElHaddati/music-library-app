#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <string>
#include <vector>
#include <memory>
#include "Song.h"

using namespace std;

class Playlist {
public:
    Playlist(const string& name) : name(name) {}

    string getName() const { return name; }

    void addSong(const shared_ptr<Song>& song) {
        songs.push_back(song);
    }

    void removeSong(const shared_ptr<Song>& song) {
        // Simple removal logic, can be improved
        for (auto it = songs.begin(); it != songs.end(); ++it) {
            if (*it == song) {
                songs.erase(it);
                break;
            }
        }
    }

    const vector<shared_ptr<Song>>& getSongs() const {
        return songs;
    }

private:
    string name;
    vector<shared_ptr<Song>> songs;
};

#endif // PLAYLIST_H