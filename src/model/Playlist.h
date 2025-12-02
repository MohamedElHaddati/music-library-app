#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <QString>
#include <vector>

class Playlist {
public:
    Playlist();
    Playlist(int id, const QString& title);

    int getId() const;
    void setId(int id);

    QString getTitle() const;
    void setTitle(const QString& title);

private:
    int m_id;
    QString m_title;
};

#endif // PLAYLIST_H
