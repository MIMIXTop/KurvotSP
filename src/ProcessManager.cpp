#include "ProcessManager.hpp"
#include "loger.hpp"

#include <QProcess>
#include <QDebug>
#include <unistd.h>
#include <sys/wait.h>
#include <vector>
#include <string>
#include <dirent.h>
#include <unistd.h>
#include <sys/types.h>
#include <fstream>
#include <sstream>

void ProcessManager::launchTermunal(const QByteArray &socketName)
{
    Loger::log("Launcher::launchTermunal called with socket: " + std::string(socketName.constData()));
    qInfo() << "Compositor running on socket:" << socketName;

    QProcess *terminal = new QProcess(this);
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("WAYLAND_DISPLAY", QString::fromLocal8Bit(socketName));
    terminal->setProcessEnvironment(env);

    Loger::log("Starting konsole terminal with WAYLAND_DISPLAY=" + std::string(socketName.constData()));
    terminal->start("konsole", QStringList());

    if (this->appPid != getpid())
    {
        this->appPid = getpid();
    }
    std::vector<pid_t> children;
    iterate_children(this->appPid, children);
    for (auto child : children)
    {
        if (get_process_name(child) == "konsole")
        {
            std::vector<pid_t> childChildren;
            iterate_children(child, childChildren);
            processes[child] = {child, std::move(get_process_name(child)), std::move(childChildren)};
        }
    }

    if (!terminal->waitForStarted())
    {
        std::string errorMsg = "Failed to start terminal: " + terminal->errorString().toStdString();
        Loger::log(errorMsg);
        qWarning() << "Failed to start terminal:" << terminal->errorString();
    }
    else
    {
        Loger::log("Terminal started successfully");
    }
}

void ProcessManager::iterate_children(pid_t pid, std::vector<pid_t> &all_children)
{
    std::string taskDir = "/proc/" + std::to_string(pid) + "/task";
    DIR *dir = opendir(taskDir.c_str());
    if (!dir)
        return;

    struct dirent *entry;
    while ((entry = readdir(dir)) != nullptr)
    {
        if (entry->d_type == DT_DIR)
        {
            std::string tid = entry->d_name;
            if (tid == "." || tid == "..")
                continue;

            std::string childrenFile = taskDir + "/" + tid + "/children";
            std::ifstream file(childrenFile);
            if (!file.is_open())
                continue;

            std::string line;
            while (std::getline(file, line))
            {
                std::istringstream iss(line);
                pid_t child;
                while (iss >> child)
                {
                    all_children.push_back(child);
                    iterate_children(child, all_children);
                }
            }
        }
    }
    closedir(dir);
}

std::string ProcessManager::get_process_name(pid_t pid)
{
    std::string commFile = "/proc/" + std::to_string(pid) + "/comm";
    std::ifstream file(commFile);
    if (!file.is_open())
        return "[unknown]";
    std::string name;
    std::getline(file, name);
    return name;
}