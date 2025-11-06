#ifndef SONG_H
#define SONG_H

#include <string>

using namespace std;

class Song {
public:
    Song(const string& title, const string& artist, const string& album,
         const string& genre, int duration, int rating, const string& filePath)
        : title(title), artist(artist), album(album), genre(genre),
          duration(duration), rating(rating), filePath(filePath) {}

    // Getters
    string getTitle() const { return title; }
    string getArtist() const { return artist; }
    string getAlbum() const { return album; }
    string getGenre() const { return genre; }
    int getDuration() const { return duration; }
    int getRating() const { return rating; }
    string getFilePath() const { return filePath; }

    // Setters
    void setTitle(const string& newTitle) { title = newTitle; }
    void setArtist(const string& newArtist) { artist = newArtist; }
    void setAlbum(const string& newAlbum) { album = newAlbum; }
    void setGenre(const string& newGenre) { genre = newGenre; }
    void setDuration(int newDuration) { duration = newDuration; }
    void setRating(int newRating) { rating = newRating; }
    void setFilePath(const string& newFilePath) { filePath = newFilePath; }

private:
    string title;
    string artist;
    string album;
    string genre;
    int duration; // in seconds
    int rating;   // 1 to 5
    string filePath; // Path to the mp3 file
};

#endif