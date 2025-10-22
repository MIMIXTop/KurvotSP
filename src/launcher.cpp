#include "launcher.h"

#include <QProcess>
#include <QDebug>

void Launcher::launchTermunal(const QByteArray &socketName) {
    qInfo() << "Compositor running on socket:" << socketName;

    QProcess *terminal = new QProcess(this);
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("WAYLAND_DISPLAY", QString::fromLocal8Bit(socketName));
    terminal->setProcessEnvironment(env);
    terminal->start("konsole", QStringList());

    if (!terminal->waitForStarted()) {
        qWarning() << "Failed to start terminal:" << terminal->errorString();
    }
}