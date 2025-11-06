#ifndef ARTIST_H
#define ARTIST_H

#include <string>
#include <vector>

using namespace std;

class Artist {
public:
    Artist(const string& name) : name(name) {}

    string getName() const { return name; }
    const vector<string>& getAlbumTitles() const { return albumTitles; }

    void addAlbumTitle(const string& albumTitle) {
        albumTitles.push_back(albumTitle);
    }

private:
    string name;
    vector<string> albumTitles;
};

#endif // ARTIST_H