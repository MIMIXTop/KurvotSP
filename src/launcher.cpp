#include "launcher.hpp"
#include "loger.hpp"

#include <QProcess>
#include <QDebug>

void Launcher::launchTermunal(const QByteArray &socketName) {
    Loger::log("Launcher::launchTermunal called with socket: " + std::string(socketName.constData()));
    qInfo() << "Compositor running on socket:" << socketName;

    QProcess *terminal = new QProcess(this);
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("WAYLAND_DISPLAY", QString::fromLocal8Bit(socketName));
    terminal->setProcessEnvironment(env);
    
    Loger::log("Starting konsole terminal with WAYLAND_DISPLAY=" + std::string(socketName.constData()));
    terminal->start("konsole", QStringList());

    if (!terminal->waitForStarted()) {
        std::string errorMsg = "Failed to start terminal: " + terminal->errorString().toStdString();
        Loger::log(errorMsg);
        qWarning() << "Failed to start terminal:" << terminal->errorString();
    } else {
        Loger::log("Terminal started successfully");
    }
}
