#include "Playlist.h"

Playlist::Playlist() : m_id(-1) {}

Playlist::Playlist(int id, const QString& title)
    : m_id(id), m_title(title) {}

void Playlist::setId(int id) { m_id = id; }

void Playlist::setTitle(const QString& title) { m_title = title; }
