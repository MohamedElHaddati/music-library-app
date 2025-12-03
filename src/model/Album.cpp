#include "Album.h"

Album::Album() : m_id(-1) {}

Album::Album(int id, const QString& title, const QString& coverPath)
    : m_id(id), m_title(title), m_coverPath(coverPath) {}

void Album::setId(int id) { m_id = id; }

void Album::setTitle(const QString& title) { m_title = title; }

void Album::setCoverPath(const QString& path) { m_coverPath = path; }
