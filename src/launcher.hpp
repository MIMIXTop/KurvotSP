#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>

class Launcher : public QObject
{
    Q_OBJECT
public:
    using QObject::QObject;

    Q_INVOKABLE void launchTermunal(const QByteArray &socketName);

private:
    void spawn(const std::string& cmd);
};

#endif // LAUNCHER_H
