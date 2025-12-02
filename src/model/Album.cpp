#include "Album.h"

Album::Album() : m_id(-1) {}

Album::Album(int id, const QString& title, const QString& coverPath)
    : m_id(id), m_title(title), m_coverPath(coverPath) {}

int Album::getId() const { return m_id; }
void Album::setId(int id) { m_id = id; }

QString Album::getTitle() const { return m_title; }
void Album::setTitle(const QString& title) { m_title = title; }

QString Album::getCoverPath() const { return m_coverPath; }
void Album::setCoverPath(const QString& path) { m_coverPath = path; }
