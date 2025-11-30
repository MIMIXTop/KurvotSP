#include "ProcessManager.hpp"
#include "loger.hpp"

#include <QDebug>
#include <QProcess>
#include <dirent.h>
#include <fstream>
#include <sstream>
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>

void ProcessManager::launchTermunal(const QByteArray &socketName) {
  Loger::log("Launcher::launchTermunal called with socket: " +
             std::string(socketName.constData()));
  qInfo() << "Compositor running on socket:" << socketName;

  QProcess *terminal = new QProcess(this);
  QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

  env.insert("WAYLAND_DISPLAY", QString::fromLocal8Bit(socketName));
  terminal->setProcessEnvironment(env);

  Loger::log("Starting konsole terminal with WAYLAND_DISPLAY=" +
             std::string(socketName.constData()));
  terminal->start("konsole", QStringList());

  if (!terminal->waitForStarted()) {
    std::string errorMsg =
        "Failed to start terminal: " + terminal->errorString().toStdString();
    Loger::log(errorMsg);
    qWarning() << "Failed to start terminal:" << terminal->errorString();
  } else {
    Loger::log("Terminal started successfully");
  }
}

void ProcessManager::shutdown() {
  Loger::log("ProcessManager::shutdown called - initiating system shutdown");
  qInfo() << "Initiating system shutdown...";

  QProcess *shutdownProcess = new QProcess();

  // Используем systemctl для выключения системы
  shutdownProcess->start("systemctl", QStringList() << "poweroff");

  if (!shutdownProcess->waitForStarted()) {
    std::string errorMsg = "Failed to start shutdown: " +
                           shutdownProcess->errorString().toStdString();
    Loger::log(errorMsg);
    qWarning() << "Failed to initiate shutdown:"
               << shutdownProcess->errorString();
  } else {
    Loger::log("Shutdown command executed successfully");
  }
}

void ProcessManager::reboot() {
  Loger::log("ProcessManager::reboot called - initiating system reboot");
  qInfo() << "Initiating system reboot...";

  QProcess *rebootProcess = new QProcess();

  // Используем systemctl для перезагрузки системы
  rebootProcess->start("systemctl", QStringList() << "reboot");

  if (!rebootProcess->waitForStarted()) {
    std::string errorMsg =
        "Failed to start reboot: " + rebootProcess->errorString().toStdString();
    Loger::log(errorMsg);
    qWarning() << "Failed to initiate reboot:" << rebootProcess->errorString();
  } else {
    Loger::log("Reboot command executed successfully");
  }
}

void ProcessManager::launchProgram(const QString &command,
                                   const QByteArray &socketName) {
  Loger::log("Launching external command: " + command.toStdString());
  qInfo() << "Compositor running on socket:" << socketName;
  qInfo() << "Command: " << command;
  QProcess *process = new QProcess(this);
  QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

  // Жизненно важно для Wayland
  env.insert("WAYLAND_DISPLAY", QString::fromLocal8Bit(socketName));

  process->setProcessEnvironment(env);

  // Используем startCommand, чтобы Qt сам распарсил аргументы (например "rofi
  // -show drun")
  process->startCommand(command);

  if (!process->waitForStarted()) {
    qWarning() << "Failed to start" << command << ":" << process->errorString();
    process->deleteLater();
  }

  // Rofi завершается сразу после выбора, поэтому процесс удалится сам,
  // но лучше подчистить память:
  connect(process,
          QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
          process, &QProcess::deleteLater);
}
