#include "Song.h"

Song::Song() : m_id(-1), m_albumId(0), m_duration(0) {}

Song::Song(int id, const QString& title, const QString& artist, const QString& filePath, int albumId, int duration)
    : m_id(id), m_title(title), m_artist(artist), m_filePath(filePath), m_albumId(albumId), m_duration(duration) {}

int Song::getId() const { return m_id; }
void Song::setId(int id) { m_id = id; }

QString Song::getTitle() const { return m_title; }
void Song::setTitle(const QString& title) { m_title = title; }

QString Song::getArtist() const { return m_artist; }
void Song::setArtist(const QString& artist) { m_artist = artist; }

QString Song::getFilePath() const { return m_filePath; }
void Song::setFilePath(const QString& filePath) { m_filePath = filePath; }

int Song::getAlbumId() const { return m_albumId; }
void Song::setAlbumId(int albumId) { m_albumId = albumId; }

int Song::getDuration() const { return m_duration; }
void Song::setDuration(int duration) { m_duration = duration; }
