#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>

class ProcessManager : public QObject {
  Q_OBJECT
public:
  using QObject::QObject;

  Q_INVOKABLE void launchTermunal(const QByteArray &socketName);
  Q_INVOKABLE void shutdown();
  Q_INVOKABLE void reboot();
  Q_INVOKABLE void launchProgram(const QString &command,
                                 const QByteArray &socketName);

  ProcessManager *instance() {
    static ProcessManager inst;
    return &inst;
  }

  ProcessManager(const ProcessManager &) = delete;
  ProcessManager &operator=(const ProcessManager &) = delete;
  ProcessManager(ProcessManager &&) = delete;
  ProcessManager &operator=(ProcessManager &&) = delete;

private:
};

#endif // LAUNCHER_H
