#include "ConfigManager.hpp"
#include "loger.hpp"
#include <QDir>
#include <QFileInfo>

ConfigManager::ConfigManager(QObject *parent) : QObject(parent) {
  m_watcher = new QFileSystemWatcher(this);
  connect(m_watcher, &QFileSystemWatcher::fileChanged, this,
          &ConfigManager::onFileChanged);

  loadConfig();

  // Watch the user config if it exists (only filesystem paths can be watched)
  if (!m_configPath.startsWith("qrc:") && QFile::exists(m_configPath)) {
    m_watcher->addPath(m_configPath);
    Loger::log("Watching config file: " + m_configPath.toStdString());
  }
}

QString ConfigManager::terminal() const { return m_config.value("terminal"); }

QString ConfigManager::folderManager() const { return m_config.value("folderManager"); }

QString ConfigManager::browser() const { return m_config.value("browser"); }

QString ConfigManager::codeRedactor() const { return m_config.value("codeRedactor"); }

QString ConfigManager::wofi() const { return m_config.value("wofi"); }

QString ConfigManager::telegram() const { return m_config.value("telegram"); }

QString ConfigManager::keyTerminal() const { return m_config.value("key_terminal"); }

QString ConfigManager::keyFolderManager() const {
    return m_config.value("key_folderManager");
}

QString ConfigManager::keyBrowser() const { return m_config.value("key_browser"); }

QString ConfigManager::keyCodeRedactor() const { return m_config.value("key_codeRedactor"); }

QString ConfigManager::keyWofi() const { return m_config.value("key_wofi"); }

QString ConfigManager::keyCloseWindow() const { return m_config.value("key_closeWindow"); }

QString ConfigManager::keyTelegram() const { return m_config.value("key_telegram"); }

QString ConfigManager::backgroundColor() const {
    QString v = m_config.value("backgroundColor");
    return v.isEmpty() ? "#333333" : v;
}

QString ConfigManager::focusColor() const {
    QString v = m_config.value("focusColor");
    return v.isEmpty() ? "#00FF00" : v;
}

int ConfigManager::windowSpacing() const {
    QString v = m_config.value("windowSpasing");
    return v.isEmpty() ? 20 : v.toInt();
}

int ConfigManager::borderSize() const {
    QString v = m_config.value("borderSize");
    return v.isEmpty() ? 4 : v.toInt();
}

QString ConfigManager::backgroundImage() const {
    QString v = m_config.value("backgroundImage");
    return v.isEmpty() ? "qrc:/src/Resource/background.jpg" : v;
}

int ConfigManager::maxWindows() const {
    QString v = m_config.value("maxWindows");
    return v.isEmpty() ? 10 : v.toInt();
}

QString ConfigManager::configPath() const { return m_configPath; }

void ConfigManager::onFileChanged(const QString &path) {
  Loger::log("Config file changed: " + path.toStdString());
  qInfo() << "Config file changed:" << path;
  // Re-add the path if it was deleted/recreated (common with some editors)
  if (!m_watcher->files().contains(path) && QFile::exists(path)) {
    m_watcher->addPath(path);
  }
  loadConfig();
}

void ConfigManager::loadConfig() {
  QStringList configPaths = {"compositor.conf",
                             QDir::homePath() + "/.config/compositor.conf",
                             "/home/mimixtop/Projects/FutureKurvot/"
                             "TemplateWaylandCompositor/compositor.conf"};

  m_configPath.clear();
  QFile file;

  for (const QString &path : configPaths) {
    file.setFileName(path);
    if (file.exists()) {
      m_configPath = path;
      Loger::log("Found config at: " + path.toStdString());
      break;
    }
  }

  if (m_configPath.isEmpty()) {
    Loger::log("No config file found, using defaults");
    qWarning() << "No compositor.conf found";
    return;
  }

  if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    Loger::log("Failed to open " + m_configPath.toStdString());
    qWarning() << "Failed to open" << m_configPath;
    return;
  }

  m_config.clear(); // Clear old config

  QTextStream in(&file);
  while (!in.atEnd()) {
    QString line = in.readLine().trimmed();
    if (line.isEmpty() || line.startsWith("#"))
      continue;

    QStringList parts = line.split("=");
    if (parts.size() >= 2) {
      QString key = parts[0].trimmed();
      QString value = parts.mid(1).join("=").trimmed(); // Handle values with =
      m_config[key] = value;
      Loger::log("Config: " + key.toStdString() + " = " + value.toStdString());
    }
  }
  file.close();

  emit configChanged();
  Loger::log("Configuration reloaded from: " + m_configPath.toStdString());
}
