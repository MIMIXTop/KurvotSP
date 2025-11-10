#ifndef LOGER_HPP
#define LOGER_HPP

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

class Loger {
public:
    static void log(const std::string& str) {
        instance().file << str << std::endl;
    }

private:
    static const std::string& getLogFileDir() {
        static const std::string logFileDir = std::string(std::getenv("HOME")) + "/.logs";
        return logFileDir;
    }
    
    static const std::string& getLogFile() {
        static const std::string logFile = "/compositor.log";
        return logFile;
    }

    Loger() {
        if (!std::filesystem::exists(getLogFileDir())) {
            if (!std::filesystem::create_directories(getLogFileDir())) {
                throw std::runtime_error("Не удалось создать директорию!");
            }
        }

        file.open(getLogFileDir() + getLogFile(), std::ios::app);
        if (!file) {
            throw std::runtime_error("Не удалось создать файл!");
        }
    }

    ~Loger() { file.close(); }

    static Loger& instance() {
        static Loger inst;
        return inst;
    }

    std::ofstream file;
};

#endif
