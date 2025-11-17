#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
#include <unordered_map>

class ProcessManager : public QObject
{
    Q_OBJECT
public:

    using QObject::QObject;

    Q_INVOKABLE void launchTermunal(const QByteArray &socketName);



    ProcessManager* instance() {
        static ProcessManager inst;
        return &inst;
    }

    ProcessManager(const ProcessManager&) = delete;
    ProcessManager& operator=(const ProcessManager&) = delete;
    ProcessManager(ProcessManager&&) = delete;
    ProcessManager& operator=(ProcessManager&&) = delete;

    struct Process
    {
        pid_t pid;
        std::string name;
        std::vector<pid_t> children;
    };
    

private:
    void iterate_children(pid_t pid, std::vector<pid_t> &all_children);

    std::string get_process_name(pid_t pid);

    std::unordered_map<pid_t, Process> processes;
    pid_t appPid = 0;
    std::string termName = "konsole";
};

#endif // LAUNCHER_H
