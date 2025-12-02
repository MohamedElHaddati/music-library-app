#ifndef SONG_H
#define SONG_H

#include <string>
#include <QString>

class Song {
public:
    Song();
    Song(int id, const QString& title, const QString& artist, const QString& filePath, int albumId = 0, int duration = 0);

    int getId() const;
    void setId(int id);

    QString getTitle() const;
    void setTitle(const QString& title);

    QString getArtist() const;
    void setArtist(const QString& artist);

    QString getFilePath() const;
    void setFilePath(const QString& filePath);

    int getAlbumId() const;
    void setAlbumId(int albumId);

    int getDuration() const;
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
