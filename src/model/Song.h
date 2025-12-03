#ifndef SONG_H
#define SONG_H

#include <string>
#include <QString>

class Song {
public:
    Song();
    Song(int id, const QString& title, const QString& artist, const QString& filePath, int albumId = 0, int duration = 0);

    int getId() const { return m_id; }
    void setId(int id);

    QString getTitle() const { return m_title; }
    void setTitle(const QString& title) { m_title = title; }

    QString getArtist() const { return m_artist; }
    void setArtist(const QString& artist) { m_artist = artist; }

    QString getFilePath() const { return m_filePath; }
    void setFilePath(const QString& filePath);

    int getAlbumId() const { return m_albumId; }
    void setAlbumId(int albumId) { m_albumId = albumId; }

    int getDuration() const { return m_duration; }
    void setDuration(int duration);

private:
    int m_id;
    QString m_title;
    QString m_artist;
    QString m_filePath;
    int m_albumId;
    int m_duration;
};

#endif // SONG_H
