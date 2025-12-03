#include "Song.h"

Song::Song() : m_id(-1), m_albumId(0), m_duration(0) {}

Song::Song(int id, const QString& title, const QString& artist, const QString& filePath, int albumId, int duration)
    : m_id(id), m_title(title), m_artist(artist), m_filePath(filePath), m_albumId(albumId), m_duration(duration) {}

void Song::setId(int id) { m_id = id; }

void Song::setFilePath(const QString& filePath) { m_filePath = filePath; }

void Song::setDuration(int duration) { m_duration = duration; }
