#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

inline const std::string logFileDir = std::string(std::getenv("HOME")) + "/.logs";
inline const std::string logFile = "/compositor.log";

class Loger {
public:
    static void log(const std::string& str) {
        instance().file << str << std::endl;
    }

private:
    Loger() {
        if (!std::filesystem::exists(logFileDir)) {
            if (!std::filesystem::create_directories(logFileDir)) {
                throw std::runtime_error("Не удалось создать директорию!");
            }
        }

        file.open(logFileDir + logFile, std::ios::app);
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