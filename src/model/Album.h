#ifndef ALBUM_H
#define ALBUM_H

#include <QString>
#include <vector>
#include "Song.h"

class Album {
public:
    Album();
    Album(int id, const QString& title, const QString& coverPath = "");

    int getId() const;
    QString getTitle() const;
    QString getCoverPath() const;

    void setId(int id);
    void setTitle(const QString& title);
    void setCoverPath(const QString& path);

private:
    int m_id;
    QString m_title;
    QString m_coverPath;
};

#endif // ALBUM_H
