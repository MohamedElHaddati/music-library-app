#include "Playlist.h"

Playlist::Playlist() : m_id(-1) {}

Playlist::Playlist(int id, const QString& title)
    : m_id(id), m_title(title) {}

int Playlist::getId() const { return m_id; }
void Playlist::setId(int id) { m_id = id; }

QString Playlist::getTitle() const { return m_title; }
void Playlist::setTitle(const QString& title) { m_title = title; }
