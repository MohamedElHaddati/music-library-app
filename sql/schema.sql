CREATE TABLE IF NOT EXISTS songs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    artist TEXT,
    album_id INTEGER,
    duration INTEGER,
    file_path TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS albums (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    cover_path TEXT
);

CREATE TABLE IF NOT EXISTS playlists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS playlist_songs (
    playlist_id INTEGER,
    song_id INTEGER,
    FOREIGN KEY(playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,
    FOREIGN KEY(song_id) REFERENCES songs(id) ON DELETE CASCADE,
    PRIMARY KEY (playlist_id, song_id)
);

-- Sample Data
INSERT OR IGNORE INTO albums (id, title, cover_path) VALUES (1, 'Greatest Hits', '');
INSERT OR IGNORE INTO albums (id, title, cover_path) VALUES (2, 'Summer Vibes', '');

INSERT OR IGNORE INTO songs (id, title, artist, album_id, duration, file_path) VALUES (1, 'Sample Song 1', 'Unknown Artist', 1, 180, 'C:/Music/song1.mp3');
INSERT OR IGNORE INTO songs (id, title, artist, album_id, duration, file_path) VALUES (2, 'Sample Song 2', 'Famous Singer', 1, 200, 'C:/Music/song2.mp3');
INSERT OR IGNORE INTO songs (id, title, artist, album_id, duration, file_path) VALUES (3, 'Summer Breeze', 'Band X', 2, 240, 'C:/Music/song3.mp3');

INSERT OR IGNORE INTO playlists (id, title) VALUES (1, 'Favorites');
INSERT OR IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (1, 1);
INSERT OR IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (1, 3);
