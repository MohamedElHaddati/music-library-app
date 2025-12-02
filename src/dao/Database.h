#ifndef DATABASE_H
#define DATABASE_H

#include <QSqlDatabase>
#include <QString>

class Database {
public:
    static Database& instance();
    bool connect();
    void initialize();
    QSqlDatabase getDatabase() const;

private:
    Database();
    ~Database();
    QSqlDatabase m_db;
};

#endif // DATABASE_H
