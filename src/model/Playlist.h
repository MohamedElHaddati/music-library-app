#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QString>
#include <vector>

class Playlist {
public:
    Playlist();
    Playlist(int id, const QString& title);

    int getId() const { return m_id; }
    void setId(int id);

    QString getTitle() const { return m_title; }
    void setTitle(const QString& title);

private:
    int m_id;
    QString m_title;
};

#endif // PLAYLIST_H
